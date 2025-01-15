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
    ../common/optional/tailscale.nix
    ../common/optional/yabai.nix

    ../common/users/thomas
    ../common/users/thomas/desktop.nix
    ./users/thomas.nix
  ];

  environment.systemPackages = with pkgs; [
    unstable.arc-browser
    unstable.obsidian
    unstable.raycast
    unstable.utm
    # pkgs.unstable.zed-editor
    # alacritty
    jq
  ];

  # TODO: this should go into a module and be added when homebrew is enabled
  environment.shellInit = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  homebrew = {
    casks = [
      # "mac-mouse-fix"
      "alacritty"
      # "bitwarden"
      # "brave-browser"
      # "docker"
      # "deepl"
      "hot"
      # "ledger-live"
      # "mullvadvpn"
      "obsidian"
      "openaudible"
      "signal"
      # "tailscale"
      "tor-browser"
      "protonvpn"
      "vlc"
      # "whatsapp"
      # "krunkit"
    ];

    masApps = {
      # "Bitwarden" = 1352778147;
      "Yubico Authenticator" = 1497506650;
      # "UTM Virtual Machines" = 1538878817; costs $9.99 in the app store
      # "Speechify" = 1624912180;
      # "DaVinci Resolve" = 571213070;
      # "Orbot" = 1609461599;

      # Safari Extensions
      # "AdGuard for Safari" = 1440147259;
      # "Bitwarden for Safari" = 1352778147;
      # "SimpleLogin" = 1494051017;
      # "Video Speed Controller" = 1588368612;
      # "Vimari" = 1480933944;
      # "XCode" = 497799835;
    };

    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
  };

  networking = {
    hostName = "meili";
    remoteLogin = true;
  };

  time.timeZone = "America/Lima";
  system.stateVersion = 4;
}
