#!/run/current-system/sw/bin/bash
set -euo pipefail

if [[ "$1" == "ssh" ]]; then
  mkdir ~/.ssh && touch ~/.ssh/authorized_keys
  curl https://github.com/tstachl.keys >> ~/.ssh/authorized_keys
  ifconfig
  exit 0
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "This script must be run as root"
   exit 1
fi

# define usage function
usage() {
  echo "Usage: $(basename "$0") [-h] [-i] [-s size] [ACTION] HOSTNAME DEVICE [DEVICE...]"
  echo "  -h: Show usage information"
  echo "  -i: Enable impermanence"
  echo "  -s: Define swap size in GB (default: 2)"
  echo "  ACTION: Action to perform (mount or create). Defaults to mount."
  echo "  HOSTNAME: Hostname"
  echo "  DEVICE: One or more block devices"
  exit 0
}

# define default values
action=mount
swap_size=2
impermanence=false

# parse command line options
while getopts ":his:" opt; do
  case ${opt} in
    h ) usage ;;
    i ) impermanence=true ;;
    s ) swap_size=$OPTARG ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      usage
      ;;
  esac
done

# shift options so that positional parameters start from $1 again
shift $((OPTIND -1))

# check if the first argument is an action
if [[ "$1" == "mount" || "$1" == "create" ]]; then
    action="$1"
    shift
fi

# validate required arguments
if [ $# -lt 2 ]; then
  echo "Invalid number of arguments." 1>&2
  usage
fi

if [ -z "$1" ]; then
  echo "Hostname is required." 1>&2
  usage
fi

for device in "${@:2}"; do
  if ! [[ -b "${device}" ]]; then
    echo "${device} is not a block device." 1>&2
    usage
  fi
done

# set variables from arguments
hostname=$1
devices=${*:2}

# output selected options and arguments
echo "Action: ${action}"
echo "Impermanence: ${impermanence}"
echo "Swap size: ${swap_size}GB"
echo "Hostname: ${hostname}"
echo "Block devices: ${devices}"

# How to name the partitions. This will be visible in 'gdisk -l /dev/disk' and
# in /dev/disk/by-partlabel.
PART_MBR="${PART_MBR:=bootcode}"
PART_EFI="${PART_EFI:=efiboot}"
PART_BOOT="${PART_BOOT:=bpool}"
PART_SWAP="${PART_SWAP:=swap}"
PART_ROOT="${PART_ROOT:=rpool}"

# partition the block devices
function _partition {
  local i=0

  for (( i=0; i<${#devices[@]}; i++ )); do
    # wipe flash-based storage device to improve
    # performance.
    # ALL DATA WILL BE LOST
    # blkdiscard -f $i

    sgdisk --zap-all "${devices[$i]}"
    sgdisk -a 1 -n 0:0:+100K -t 0:EF02 -c "0:${PART_MBR}${i}" "${devices[$i]}"
    sgdisk -n 0:1M:+1G -t 0:EFF00 -c "0:${PART_EFI}${i}" "${devices[$i]}"
    sgdisk -n 0:0:+4G -t 0:BE00 -c "0:${PART_BOOT}${i}" "${devices[$i]}"
    (( swap_size )) && sgdisk -n "0:0:+${swap_size}G" -t 0:8200 -c "0:${PART_SWAP}${i}" "${devices[$i]}"
    sgdisk -n 0:0:0 -t 0:BF00 -c "0:${PART_ROOT}${i}" "${devices[$i]}"

    sync && udevadm settle && sleep 2

    if (( swap_size )); then
      cryptsetup open --type plain --key-file /dev/random "${devices[$i]}4" "${PART_SWAP}${i}"
      mkswap "/dev/mapper/${PART_SWAP}${i}"
      swapon "/dev/mapper/${PART_SWAP}${i}"
    fi

    (( i++ )) || true
  done

  unset i
}

# How to name the boot pool and root pool.
ZFS_BOOT="${ZFS_BOOT:=bpool}"
ZFS_ROOT="${ZFS_ROOT:=rpool}"

# How to name the root volume in which nixos will be installed.
# If ZFS_ROOT is set to "rpool" and ZFS_ROOT_VOL is set to "nixos",
# nixos will be installed in rpool/nixos, with a few extra subvolumes
# (datasets).
ZFS_ROOT_VOL="${ZFS_ROOT_VOL:=nixos}"

# Generate a root password with mkpasswd -m SHA-512
ROOTPW="${ROOTPW:-}"

# If IMPERMANENCE is 1, this will be the name of the empty snapshots
EMPTYSNAP="${EMPTYSNAP:-EMPTY}"

function _create {
  if [ "${#device[@]}" -gt "1" ]; then
    mirror="${ZFS_BOOT} mirror"
  else
    mirror="${ZFS_BOOT}"
  fi

  echo "before create"

  # create the boot pool
  zpool create \
    -o compatibility=grub2 \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/boot \
    -R /mnt \
    "${mirror}" "/dev/disk/by-partlabel/${PART_BOOT}*"

  echo "after create boot"

  # create the root pool
  zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    -R /mnt \
    "${mirror}" "/dev/disk/by-partlabel/${PART_ROOT}*"

  echo "after create root"

  unset mirror

  # create root system container - TODO: think about encryption
  zfs create -o canmount=off -o mountpoint=none "${ZFS_ROOT}/${ZFS_ROOT_VOL}"
  # create boot container
  zfs create -o mountpoint=none "${ZFS_BOOT}/${ZFS_ROOT_VOL}"

  # create system datasets
  zfs create -o mountpoint=legacy "${ZFS_ROOT}/${ZFS_ROOT_VOL}/home"
  zfs create -o mountpoint=legacy -o atime=off "${ZFS_ROOT}/${ZFS_ROOT_VOL}/nix"
  zfs create -o mountpoint=legacy "${ZFS_ROOT}/${ZFS_ROOT_VOL}/root"
  zfs create -o mountpoint=legacy "${ZFS_ROOT}/${ZFS_ROOT_VOL}/var"
  zfs create -o mountpoint=legacy "${ZFS_ROOT}/${ZFS_ROOT_VOL}/var/lib"
  zfs create -o mountpoint=legacy "${ZFS_ROOT}/${ZFS_ROOT_VOL}/var/log"

  # create boot datasets
  zfs create -o mountpoint=legacy "${ZFS_BOOT}/${ZFS_ROOT_VOL}/root"

  # create an empty snap
  # (( impermanence )) && zfs snapshot "${ZFS_ROOT}/${ZFS_ROOT_VOL}@${EMPTYSNAP}"

}

# function _mount {
#   # Mount Everything
#   mount -t tmpfs -o defaults,mode=755 none /mnt
#
#   [ ! -d "/mnt/nix" ] && mkdir /mnt/nix
#   [ ! -d "/mnt/persist" ] && mkdir /mnt/persist
#
#   zpool import -fd "/dev/disk/by-label/$hostname" "$hostname"
#   mount -t zfs "${hostname}/nix" /mnt/nix
#   mount -t zfs "${hostname}/persist" /mnt/persist
#
#   [ ! -d "/mnt/boot" ] && mkdir /mnt/boot
#   mount /dev/disk/by-label/boot /mnt/boot
# }

function main {
  if [ "$action" == "create" ]; then
    _partition
    _create
  fi
  _mount
}

main
