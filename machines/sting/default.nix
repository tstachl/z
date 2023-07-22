{ lib, modulesPath, ... }:
{
  imports = [
    ./hardware.nix

    ../common/global
    ../common/optional/nixos.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix
  ];

  networking.hostName = "sting";

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
