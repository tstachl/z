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

  # TODO(@tstachl): currently needed to run as a virtual machine
  virtualisation.vmVariant.virtualisation = {
    diskSize = 20000;
    graphics = false;
    host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    libvirtd.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
