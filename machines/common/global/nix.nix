{ lib, config, outputs, ... }:
{
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];

      trusted-users = [ "root" "@wheel" "thomas" ];
      auto-optimise-store = lib.mkDefault true;
    };

    extraOptions = ''
      warn-dirty = false
      experimental-features = nix-command flakes repl-flake
    '';

    gc = {
      automatic = true;
      # dates = "weekly"; TODO: this doesn't work on darwin
      options = "--delete-older-than 7d";
    };

    # Map registries to channels
    # Very useful when using legacy commands
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };
}
