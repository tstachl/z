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

# define default values
action=mount
swap_size=$(free -gh | awk -F "[, ]+" '/Mem/{printf(fmt,$2)}' fmt="%'1.2f")

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

# output selected options and arguments
echo "Action: ${action}"
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

  parted -a optimal "${device}" -- mklabel gpt
  parted -a optimal "${device}" -- mkpart ESP fat32 1MB 512MB
  parted -a optimal "${device}" -- set 3 esp on

  if [ "$swap_size" -gt "0" ]; then
    parted -a optimal "${device}" -- mkpart primary 512MB "-${swap_size}GB"
    parted -a optimal "${device}" -- mkpart primary linux-swap "-${swap_size}GB" 100%

    cryptsetup open --type plain --key-file /dev/random "${device}3" swap
    mkswap "/dev/mapper/swap"
    swapon "/dev/mapper/swap"
  else
    parted -a optimal "${device}" -- mkpart primary 512MB 100%
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
    -O realtime=on \
    -O checksum=edonr \
    rpool "${device}2"

  zfs create "rpool/local/root"
  zfs create -o atime=off "rpool/local/nix"
  zfs create "rpool/safe/persist"

  zfs snapshot "rpool/local/root@blank"

  mkfs.fat -F 32 -n boot "${device}1"
}

function _mount {
  # mount zfs
  mkdir -p /mnt
  mount -t zfs rpool/local/root /mnt
  mkdir -p /mnt/nix
  mount -t zfs rpool/local/nix /mnt/nix
  mkdir -p /mnt/persist
  mount -t zfs rpool/safe/persist /mnt/persist

  # mount boot
  mkdir -p /mnt/boot
  mount /dev/sda1 /mnt/boot
}

function _uefi_setup {
  # only works on raspi sd card
  mkdir /firmware
  mount "/dev/$(lsblk | awk 'NR==3 {print $1}' | sed 's/[^a-zA-Z0-9_:]//g')" /firmware
  rm -rf /mnt/boot/*
  cp /firmware/* /mnt/boot
}

function main {
  if [[ "$action" == "create" ]]; then
    _partition ${devices[0]}
    _create ${devices[0]}
  fi

  _mount
  _uefi_setup

  nixos-install --flake "github:tstachl/z#${hostname}"
}

main
