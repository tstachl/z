{ config, lib, modulesPath, pkgs, inputs, ... }:

with lib;

let
  cfg = config.boot.loader.raspberryPi;

  builderUboot = import "${toString modulesPath}/system/boot/loader/raspberrypi/uboot-builder.nix" { inherit pkgs configTxt; inherit (cfg) version; };
  builderGeneric = import "${toString modulesPath}/system/boot/loader/raspberrypi/raspberrypi-builder.nix" { inherit pkgs configTxt; };

  builder =
    if cfg.uboot.enable then
      "${builderUboot} -g ${toString cfg.uboot.configurationLimit} -t ${timeoutStr} -c"
    else
      "${builderGeneric} -c";

  blCfg = config.boot.loader;
  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  optional = pkgs.lib.optionalString;

  configTxt =
    pkgs.writeText "config.txt" (''
      # U-Boot used to need this to work, regardless of whether UART is actually used or not.
      # TODO: check when/if this can be removed.
      enable_uart=1

      # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
      # when attempting to show low-voltage or overtemperature warnings.
      avoid_warnings=1
    '' + optional isAarch64 ''
      # Boot in 64-bit mode.
      arm_64bit=1
    '' + (if cfg.uboot.enable then ''
      kernel=u-boot-rpi.bin
    '' else ''
      kernel=kernel.img
      initramfs initrd followkernel
    '') + optional (cfg.firmwareConfig != null) cfg.firmwareConfig);
in
{
  imports = [
    "${toString modulesPath}/installer/sd-card/sd-image-raspberrypi.nix"
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
      raspberryPi.enable = true;
      raspberryPi.version = 4;
      grub.enable = false;
      # generic-extlinux-compatible.enable = true;
    };
  };

  system.build.installBootLoader = mkForce builder;

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
