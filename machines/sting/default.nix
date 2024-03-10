{
  imports = [
    ./system/nix.nix
    ./system/hardware.nix
    ./system/user.nix
    ./system/caddy.nix
    # ./system/nginx.nix

    ./services/avahi.nix
    # ./services/tailscale.nix
    ./services/openssh.nix
    ./services/test.nix
  ];


  # TODO(@tstachl): These are the setup screen options
  networking.hostName = "sting";
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.05";
}
