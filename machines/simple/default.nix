{ lib, config, inputs, ... }:
{
  imports = [
    ./hardware.nix

    ../common/global
    ../common/optional/gnupg.nix
    ../common/optional/openssh.nix
    ../common/optional/podman.nix

    ../common/users/thomas
  ];

  networking.hostName = "simple";

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
