{
  description = "more modular configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
  };

  outputs = { self, nixpkgs, darwin, ...}@inputs:
  let
    inherit (self) outputs;
    # supportedSystems = [ "aarch64-linux" "aarch64-darwin" ];
    # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    # nixosModules = import ./modules/nixos;
    # darwinModules = import ./modules/darwin;
    # homeModules = import ./modules/home;

    # overlays = import ./overlays;

    nixosConfigurations = {
      # VPS in Chile
      thor = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; inherit outputs; };
        modules = [
          ./hosts/thor
          ./services/git
          ./users/thomas
        ];
      };
    };

    darwinConfigurations = {
      # Macbook Air M2
      meili = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; inherit outputs; };
        modules = [ ./hosts/meili ./users/thomas ];
      };
    };
  };
}
