{ pkgs, lib, config, outputs, ... }:
{
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      trusted-users = [ "root" "@wheel" ];

      auto-optimise-store = lib.mkDefault true;
    };

    package = pkgs.nixUnstable;

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes repl-flake
      warn-dirty = false
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
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };
}
