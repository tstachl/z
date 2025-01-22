{
  imports = [
    ./hardware.nix

    ../common/global
    ../common/optional/gnupg.nix
    ../common/optional/locale.nix
    ../common/optional/fish.nix
    ../common/optional/nixos.nix
    ../common/optional/openssh.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  networking.hostName = "modgud";
  time.timeZone = "Europe/Amsterdam";
  system.stateVersion = "25.05";
}
