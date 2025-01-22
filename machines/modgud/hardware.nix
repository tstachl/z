{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/34cb7b7b-d5c6-4d3f-be62-306369e914af";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/34cb7b7b-d5c6-4d3f-be62-306369e914af";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/34cb7b7b-d5c6-4d3f-be62-306369e914af";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  networking.useDHCP = lib.mkDefault true;
}
