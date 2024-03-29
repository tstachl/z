{ modulesPath, ... }:
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
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];

  systemd.network.enable = false;
  systemd.network.networks."99-ethernet-default-dhcp" = {
    matchConfig.Name = "en*";
    linkConfig.RequiredForOnline = false;

    networkConfig.DHCP = "yes";
    networkConfig.IPv6PrivacyExtensions = "kernel";
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
