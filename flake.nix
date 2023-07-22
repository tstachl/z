{
  description = "more modular configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , darwin
    , home-manager
    , flake-utils
    }@inputs:

      {
        nixosModules = import ./modules/nixos;
        darwinModules = import ./modules/darwin;
        homeManagerModules = import ./modules/home-manager;
      }

      //

      flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [];
        pkgs = import nixpkgs {
          inherit overlays system;
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        };
      in {

        packages = {

          nixosConfigurations = {
            simple = nixpkgs.lib.nixosSystem {
              inherit pkgs;
              specialArgs = { inherit inputs; inherit (self) outputs; };

              modules = [ ./machines/simple ];
            };

            sting = nixpkgs.lib.nixosSystem {
              inherit pkgs;
              specialArgs = { inherit inputs; inherit (self) outputs; };

              modules = [ ./machines/sting ];
              # get all the apps for sting and load them as modules
              # modules = map (file: "${./modules/sting}/${file}")
              #   (builtins.attrNames (builtins.readDir ./modules/sting));
            };
          };

          darwinConfigurations = {
            meili = darwin.lib.darwinSystem {
              inherit pkgs;
              specialArgs = { inherit inputs; inherit (self) outputs; };
              modules = [ ./machines/meili ];
            };
          };

          homeConfigurations = {
            thomas = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs; inherit (self) outputs; };

              modules = [ ./users/thomas ];
            };
          };

        } // import ./pkgs { inherit pkgs; };

      });
}
