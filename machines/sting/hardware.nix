{ config, lib, modulesPath, pkgs, inputs, ... }:

with lib;

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "uas" ];
      # postDeviceCommands = lib.mkAfter ''
      #   zfs rollback -r rpool/root@blank
      # '';
    };

    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];

    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/disk/by-partuuid/561c4a9c-3202-4814-a426-d7bc40055855";
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

  hardware.geekworm-xscript = {
    fan.enable = true;
    pwr.enable = true;
  };

  swapDevices = [ { device = "/dev/mapper/swap"; } ];

  powerManagement.cpuFreqGovernor = mkDefault "ondemand";
  networking.hostId = lib.mkDefault "8425e349";
  nixpkgs.hostPlatform = "aarch64-linux";
}
