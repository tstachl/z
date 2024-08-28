{ config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid"
    "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mmcblk0p3";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/home" = {
    device = "/dev/mmcblk0p3";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mmcblk0p3";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/persist" = {
    device = "/dev/mmcblk0p3";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/mmcblk0p3";
    fsType = "btrfs";
    options = [ "subvol=log" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3415-65AA";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/264a17c8-49c3-407a-b904-227bb95f1ba5"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault
    config.hardware.enableRedistributableFirmware;
}
