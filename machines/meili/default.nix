{ pkgs, ... }:
{
  imports = [
    ../common/global

    ../common/optional/darwin.nix
    ../common/optional/gnupg.nix
    # ../common/optional/openssh.nix
    ../common/optional/skhd.nix
    ../common/optional/yabai.nix

    ../common/users/thomas
  ];

  environment.systemPackages = with pkgs; [
    # podman
  ];

  homebrew = {
    casks = [
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
      # "UTM Virtual Machines" = 1538878817; costs $9.99 in the app store
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
