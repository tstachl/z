{ modulesPath, inputs, ... }:
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

  # fileSystems = {
  #   "/boot" = {
  #     device = "/dev/disk/by-label/boot";
  #     fsType = "vfat";
  #   };
  #
  #   "/" = {
  #     device = "/dev/disk/by-label/nixos";
  #     fsType = "ext4";
  #   };
  # };
  #
  # swapDevices = [{
  #   device = "/dev/disk/by-label/swap";
  # }];

  # virtualisation.vmVariant = {
  #   virtualisation.graphics = false;
  #   virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
  # };

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  nixpkgs.hostPlatform = "aarch64-linux";
}
