{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    extraModulePackages = [ ];

    zfs = {
      devNodes = "/dev/disk/by-path";
    };
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "thor/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "thor/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;
}
