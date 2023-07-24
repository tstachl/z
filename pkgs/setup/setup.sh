# define usage function
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

# validate required arguments
if [ $# -lt 2 ]; then
  echo "Invalid number of arguments." 1>&2
  exit 1
fi

if [ -z "$1" ]; then
  echo "Hostname is required." 1>&2
  exit 1
fi

for device in "${@:2}"; do
  if ! [[ -b "${device}" ]]; then
    echo "${device} is not a block device." 1>&2
    exit 1
  fi
done
unset device

# set variables from arguments
hostname=$1
IFS=" " read -r -a devices <<< "${*:2}"

# define default values
last_column=$(gdisk -l "${devices[0]}" | awk -F "[, ]+" 'END{print $NF}')
swap_size=$(free -gh | awk -F "[, ]+" '/Mem/{printf("%.0f",$2)}')
sd_device=$(lsblk | awk 'NR==3 {print $1}' | sed 's/[^a-zA-Z0-9_:]//g')

# output selected options and arguments
echo "Swap size: ${swap_size}GB"
echo "Hostname: ${hostname}"
echo "Block devices: ${#devices[@]}"

# How to name the partitions. This will be visible in 'gdisk -l /dev/disk' and
# in /dev/disk/by-partlabel.
function _partition {
  local device=$1

  # wipe flash-based storage device to improve
  # performance.
  # ALL DATA WILL BE LOST
  wipefs -a "${device}"

  sgdisk --zap-all "${device}"
  sgdisk -n 0:1M:+1G -t 0:EF00 -c 0:boot "${device}"
  (( swap_size )) && sgdisk -n "0:0:+${swap_size}G" -t 0:8200 -c 0:swap "${device}"
  sgdisk -n 0:0:0 -t 0:BF00 -c 0:nixos "${device}"

  sync && udevadm settle && sleep 2

  if [ "$swap_size" -gt "0" ]; then
    cryptsetup open --type plain --key-file /dev/random "${device}2" swap
    mkswap "/dev/mapper/swap"
    swapon "/dev/mapper/swap"
  fi
}

function _create {
  local device=$1

  zpool create \
    -O mountpoint=none \
    -O atime=off \
    -o ashift=12 \
    -O acltype=posixacl \
    -O xattr=sa \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -o autotrim=on \
    -O canmount=off \
    -O checksum=edonr \
    rpool "${device}3"

  zfs create rpool/root
  zfs create -o atime=off rpool/nix
  zfs create rpool/persist

  zfs snapshot rpool/root@blank

  mkfs.fat -F 32 -n boot "${device}1"
}

function _mount {
  # mount zfs
  mount -t zfs -o zfsutil rpool/root /mnt
  mkdir -p /mnt/nix
  mount -t zfs -o zfsutil rpool/nix /mnt/nix
  mkdir -p /mnt/persist
  mount -t zfs -o zfsutil rpool/persist /mnt/persist

  # mount boot
  mkdir -p /mnt/boot
  mount /dev/sda1 /mnt/boot
}

function _uefi_setup {
  # only works on raspi sd card
  [-d /firmware ] || mkdir /firmware
  mount "/dev/${sd_device}" /firmware
  rm -rf /mnt/boot/*
  cp /firmware/* /mnt/boot
}

function main {
  if [[ "$last_column" != "nixos" ]]; then
    _partition "${devices[0]}"
    _create "${devices[0]}"
  fi

  _mount
  _uefi_setup

  nixos-install --flake "github:tstachl/z#${hostname}"
}

main
