{ config, lib, modulesPath, pkgs, inputs, ... }:

with lib;

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "uas" ];

    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];

    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/disk/by-label/rpool";
    consoleLogLevel = 7;
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/persist" = {
      device = "rpool/persist";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
  };

  swapDevices = [ { device = "/dev/mapper/swap"; } ];

  powerManagement.cpuFreqGovernor = mkDefault "ondemand";
  networking.hostId = lib.mkDefault "8425e349";
  hardware.raspberry-pi."4".pwm0.enable = true;
}
