#!/run/current-system/sw/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo -e "This script must be run as root"
   exit 1
fi

# How to name the partitions. This will be visible in 'gdisk -l /dev/disk' and
# in /dev/disk/by-partlabel.
PART_MBR="${PART_MBR:=bootcode}"
PART_EFI="${PART_EFI:=efiboot}"
PART_BOOT="${PART_BOOT:=bpool}"
PART_SWAP="${PART_SWAP:=swap}"
PART_ROOT="${PART_ROOT:=rpool}"

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

function _usage {
  cat <<EOM
Usage: $(basename "$0") [options] <action> <hostname> <device>

Options:
  -h          show usage information
  -i          switch on impermanence
  -s <size>   define swap size (default: 4)

Arguments:
  action      can be mount or create (default: create)
  hostname    the hostname for this machine
  device      the disk (eg. /dev/sda) or disks (eg. /dev/sda /dev/sdb)
EOM
}

swap_size=4
impermanence="${IMPERMANENCE:-0}"

while getopts ':his:' opt; do
  case $opt in
    h) _usage; exit 0;;
    i) impermanence=1;;
    s) [[ $OPTARG == ?(-)+([0-9]) ]] && swap_size=$OPTARG;;
    *) ;;
  esac
done

action=$( printf '%s\n' "${@:$OPTIND:1}" )
hostname=$( printf '%s\n' "${@:$OPTIND+1:1}" )
IFS=" " read -r -a device <<< "${@:$OPTIND+2}"

if [[ "$action" != "mount" && "$action" != "create" ]]; then
  IFS=" " read -r -a device <<< "$hostname ${device[*]}"
  hostname=$action
  action="create"
fi

if [ -z "$hostname" ]; then
  echo -e "Error: hostname is required (eg. throwaway)\n"
  _usage
  exit 1
fi

if ! [[ $hostname =~ ^[0-9a-zA-Z_-]+$ ]]; then
  echo -e "Error: hostname can only contain alphanumeric characters, underscore and dash\n"
  _usage
  exit 1
fi

if [ -z "${device[*]}" ]; then
  echo -e "Error: device is required (eg. /dev/sda)\n"
  _usage
  exit 1
fi

for i in "${device[@]}"; do
  if ! [ -b "$i" ]; then
    echo -e "Error: device ($i) has to be a blockdevice\n"
    _usage
    exit 1
  fi
done
unset i

cat << EOF
action=${action}
hostname=${hostname}
device=${device[*]}
swap_size=${swap_size}
impermanence=${impermanence}
EOF

function _partition {
  i=0

  for (( i=0; i<${#device[@]}; i++ )); do
    # wipe flash-based storage device to improve
    # performance.
    # ALL DATA WILL BE LOST
    # blkdiscard -f $i

    sgdisk --zap-all "${device[$i]}"
    sgdisk -a 1 -n 1:0:+100K -t 1:EF02 -c "1:${PART_MBR}${i}" "${device[$i]}"
    sgdisk -n 2:1M:+1G -t 2:EFF00 -c "2:${PART_EFI}${i}" "${device[$i]}"
    sgdisk -n 3:0:+4G -t 3:BE00 -c "3:${PART_BOOT}${i}" "${device[$i]}"
    sgdisk -n "4:0:+${swap_size}G" -t 4:8200 -c "4:${PART_SWAP}${i}" "${device[$i]}"

    sgdisk -n5:0:0 -t5:BF00 -c "5:${PART_ROOT}${i}" "${device[$i]}"

    sync && udevadm settle && sleep 2

    cryptsetup open --type plain --key-file /dev/random "${device[$i]}4" "${PART_SWAP}${i}"
    mkswap "/dev/mapper/${PART_SWAP}${i}"
    swapon "/dev/mapper/${PART_SWAP}${i}"

    (( i++ )) || true
  done

  unset i
}

# function _create {
#   # create the boot pool
#   mirror=$([ "${#device[@]}" -gt "1" ] && echo "mirror" || echo "" )
#   zpool create \
#     -o compatibility=grub2 \
#     -o ashift=12 \
#     -o autotrim=on \
#     -O acltype=posixacl \
#     -O canmount=off \
#     -O compression=lz4 \
#     -O devices=off \
#     -O normalization=formD \
#     -O relatime=on \
#     -O xattr=sa \
#     -O mountpoint=/boot \
#     -R /mnt \
#     ${ZFS_BOOT} ${mirror} /dev/disk/by-partlabel/${PART_BOOT}*
#
#   # create the root pool
#   zpool create \
#     -o ashift=12 \
#     -o autotrim=on \
#     -O acltype=posixacl \
#     -O canmount=off \
#     -O compression=zstd \
#     -O dnodesize=auto \
#     -O normalization=formD \
#     -O relatime=on \
#     -O xattr=sa \
#     -O mountpoint=/ \
#     -R /mnt \
#     ${ZFS_ROOT} ${mirror} /dev/disk/by-partlabel/${PART_ROOT}*
#   unset mirror
#
#   # create root system container - TODO: think about encryption
#   zfs create -o canmount=off -o mountpoint=none ${ZFS_ROOT}/${ZFS_ROOT_VOL}
#   # create boot container
#   zfs create -o mountpoint=none ${ZFS_BOOT}/${ZFS_ROOT_VOL}
#
#   # create system datasets
#   zfs create -o mountpoint=legacy ${ZFS_ROOT}/${ZFS_ROOT_VOL}/home
#   zfs create -o mountpoint=legacy -o atime=off ${ZFS_ROOT}/${ZFS_ROOT_VOL}/nix
#   zfs create -o mountpoint=legacy ${ZFS_ROOT}/${ZFS_ROOT_VOL}/root
#   zfs create -o mountpoint=legacy ${ZFS_ROOT}/${ZFS_ROOT_VOL}/var
#   zfs create -o mountpoint=legacy ${ZFS_ROOT}/${ZFS_ROOT_VOL}/var/lib
#   zfs create -o mountpoint=legacy ${ZFS_ROOT}/${ZFS_ROOT_VOL}/var/log
#
#   # create boot datasets
#   zfs create -o mountpoint=legacy ${ZFS_BOOT}/${ZFS_ROOT_VOL}/root
#
#   # create an empty snap
#   zfs snapshot "${ZFS_ROOT}/${ZFS_ROOT_VOL}${i}@${EMPTYSNAP}"
#
# }

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

[ "$action" == "create" ] && _partition # && _create
# _mount

