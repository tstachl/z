# This file defines overlays
{ inputs, ... }:
rec {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    makeModulesClosure = x:
      prev.makeModulesClosure (x // { allowMissing = true; });

    kraft = prev.kraft.overrideAttrs
      (old: inputs.nixpkgs.lib.recursiveUpdate old { meta.broken = false; });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      overlays = [ additions modifications ];
      config.allowUnfree = true;
    };
  };
}
