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
      auto-optimise-store = true;
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
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };
}
