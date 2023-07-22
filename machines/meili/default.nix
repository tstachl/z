{ pkgs, ... }:
{
  imports = [
    ../common/global

    ../common/optional/darwin.nix
    ../common/optional/fonts.nix
    ../common/optional/gnupg.nix
    # ../common/optional/openssh.nix
    ../common/optional/podman.nix # TODO: we need a module for this
    ../common/optional/skhd.nix
    ../common/optional/yabai.nix

    ../common/users/thomas
    ../common/users/thomas/desktop.nix
  ];

  homebrew = {
    casks = [
      "alacritty"
      "brave-browser"
      "deepl"
      "keepassxc"
      "ledger-live"
      "mouse-fix"
      "openaudible"
      "protonvpn"
      "syncthing"
      "whatsapp"
    ];
    masApps = {
      "Tailscale" = 1475387142;
      "Yubico Authenticator" = 1497506650;
      # # "UTM Virtual Machines" = 1538878817; costs $9.99 in the app store
      "Speechify" = 1624912180;
    };
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
  };

  networking.hostName = "meili";
  networking.remoteLogin = true;
  time.timeZone = "Europe/Vienna";
  system.stateVersion = 4;
}
