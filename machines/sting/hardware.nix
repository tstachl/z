{ config, lib, modulesPath, pkgs, inputs, ... }:

with lib;

{
  imports = [
    "${toString modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "usbhid" "uas" "usb_storage" ];
      kernelModules = [ ];
    };

    kernelPackages = mkForce pkgs.linuxPackages_rpi4;
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];

    kernelModules = [ ];
    extraModulePackages = [ ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # fileSystems = {
  #   "/boot" = {
  #     device = "/dev/disk/by-label/boot";
  #     fsType = "vfat";
  #   };

  #   "/" = {
  #     device = lib.mkForce "/dev/disk/by-label/nixos";
  #     fsType = "ext4";
  #   };
  # };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = mkDefault "ondemand";
  hardware.enableRedistributableFirmware = true;
}
