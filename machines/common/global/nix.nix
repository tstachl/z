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

      (import (fetchTarball {
        url = "https://github.com/oxalica/rust-overlay/archive/stable.tar.gz";
        sha256 = "sha256:1jjqpdc9qfyrjrka3xnxzrj8zfhp25p1im0h3a2m94sknvh1c7vi";
      }))
    ];

    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };
}
