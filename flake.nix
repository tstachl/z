{
  description = "more modular configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
  };

  outputs = { self, nixpkgs, darwin, ...}@inputs:
  let
    inherit (self) outputs;
    supportedSystems = [ "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    # nixosModules = import ./modules/nixos;
    # darwinModules = import ./modules/darwin;
    # homeModules = import ./modules/home;

    # overlays = import ./overlays;

    legacyPackages = forAllSystems (system:
      import nixpkgs {
        inherit system;
        # overlays = with outputs.overlays; [ additions modifications ];
        config.allowUnfree = true;
        config.allowUnsupportedSystem = true;
      }
    );

    packages = forAllSystems (system:
      import ./pkgs { pkgs = legacyPackages.${system}; }
    );

    nixosConfigurations = {
      # VPS in Chile
      thor = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; inherit outputs; };
        modules = [
          ./machines/thor
          ./users/thomas
        ];
      };
    };

    darwinConfigurations = {
      # Macbook Air M2
      meili = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; inherit outputs; };
        modules = [
          ./machines/meili
          ./users/thomas
        ];
      };
    };
  };
}
