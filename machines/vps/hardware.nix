{ config, lib, modulesPath, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # ../common/optional/fuse.nix
    # ../common/optional/systemd-boot.nix
  ];

  boot = {
    initrd = {
      supportedFilesystems = [ "btrfs" ];
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    extraModulePackages = [ ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
      };
      timeout = 5;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostName}";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" "nodatacow" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4096;
  }];

  # nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
}
