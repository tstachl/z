{ lib, config, inputs, ... }:
{
  imports = [
    ./hardware.nix

    ../common/global

    ../common/users/thomas.nix
  ];

  networking.hostName = "simple";

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
