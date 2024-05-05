{ pkgs, ... }:
{
  imports = [
    ../common/global

    ../common/optional/cachix.nix
    ../common/optional/darwin.nix
    ../common/optional/devenv.nix
    ../common/optional/fonts.nix
    ../common/optional/gnupg.nix
    # ../common/optional/openssh.nix
    # ../common/optional/podman.nix
    ../common/optional/skhd.nix
    ../common/optional/yabai.nix

    ../common/users/thomas
    ../common/users/thomas/desktop.nix
  ];

  environment.systemPackages = with pkgs; [
    pkgs.unstable.arc-browser
    alacritty
    jq
  ];

  homebrew = {
    taps = [ "homebrew/cask" ];

    casks = [
      "alacritty"
      # "brave-browser"
      "docker"
      # "bitwarden"
      # "deepl"
      # "ledger-live"
      "mac-mouse-fix"
      "mullvadvpn"
      "openaudible"
      # "protonvpn"
      "whatsapp"
      # "krunkit"
    ];

    masApps = {
      # "Bitwarden" = 1352778147;
      "Yubico Authenticator" = 1497506650;
      # "UTM Virtual Machines" = 1538878817; costs $9.99 in the app store
      # "Speechify" = 1624912180;
      # "DaVinci Resolve" = 571213070;
      "Orbot" = 1609461599;

      # Safari Extensions
      # "AdGuard for Safari" = 1440147259;
      # "Bitwarden for Safari" = 1352778147;
      # "SimpleLogin" = 1494051017;
      # "Video Speed Controller" = 1588368612;
      # "Vimari" = 1480933944;
    };

    enable = true;
    onActivation.upgrade = true;
  };

  networking = {
    hostName = "meili";
    remoteLogin = true;
  };

  time.timeZone = "America/Los_Angeles";
  system.stateVersion = 4;
}
