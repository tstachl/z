{
  imports = [
    ./hardware.nix

    ./user.nix

    ./services/tailscale.nix
    ./services/openssh.nix
  ];

  # TODO(@tstachl): These are the setup screen options
  networking.hostName = "sting";
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.11";
}
