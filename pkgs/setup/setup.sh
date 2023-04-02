#!/run/current-system/sw/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo -e "This script must be run as root"
   exit 1
fi

function _usage {
  cat <<EOM
Usage: $(basename "$0") [options] <action> <hostname> <device>

Options:
  -h          show usage information

Arguments:
  action      can be mount or create (default: create)
  hostname    the hostname for this machine
  device      the disk device (eg. /dev/sda)
EOM
}

action=$( printf '%s\n' "${@:$OPTIND:1}" )
hostname=$( printf '%s\n' "${@:$OPTIND+1:1}" )
device=$( printf '%s\n' "${@:$OPTIND+2:1}" )

if [[ "$action" != "mount" && "$action" != "create" ]]; then
  device=$hostname
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

if [ -z "$device" ]; then
  echo -e "Error: device is required (eg. /dev/sda)\n"
  _usage
  exit 1
fi

if ! [ -b "$device" ]; then
  echo -e "Error: device has to be a blockdevice\n"
  _usage
  exit 1
fi

function _create {
  # Creating Partitions
  parted "$device" -- mklabel gpt
  parted "$device" -- mkpart primary 512mb 100%
  parted "$device" -- mkpart ESP fat32 1mb 512mb
  parted "$device" -- set 2 esp on

  # Formatting Partitions
  mkfs.fat -F 32 -n boot "${device}2"

  zpool create -O compress=on -O mountpoint=legacy "$hostname" "${device}1" -f
  zfs create -o xattr=off -o atime=off "${hostname}/nix"
  zfs create -o xattr=off -o atime=off "${hostname}/persist"
}

function _mount {
  # Mount Everything
  mount -t tmpfs -o defaults,mode=755 none /mnt

  [ ! -d "/mnt/nix" ] && mkdir /mnt/nix
  [ ! -d "/mnt/persist" ] && mkdir /mnt/persist

  zpool import -fd "/dev/disk/by-label/$hostname" "$hostname"
  mount -t zfs "${hostname}/nix" /mnt/nix
  mount -t zfs "${hostname}/persist" /mnt/persist

  [ ! -d "/mnt/boot" ] && mkdir /mnt/boot
  mount /dev/disk/by-label/boot /mnt/boot
}

[ "$action" == "create" ] && _create
_mount

