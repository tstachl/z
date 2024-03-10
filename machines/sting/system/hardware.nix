{  modulesPath, inputs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    kernelParams = [ "console=tty1" "console=ttyS0,115200" ];
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
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
