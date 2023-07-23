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
        overlays = [
          # Needed to make building the SD Card for Raspi work
          (final: super: {
            makeModulesClosure = x:
              super.makeModulesClosure (x // { allowMissing = true; });
          })
        ];
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

              modules = [
                "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
                ./machines/sting
              ];
              # inherit pkgs;

              # modules = [ ./machines/sting ];
              # get all the apps for sting and load them as modules
              # modules = map (file: "${./modules/sting}/${file}")
              #   (builtins.attrNames (builtins.readDir ./modules/sting));
            };

            sdcard = nixpkgs.lib.nixosSystem {
              inherit pkgs;
              modules = [
                "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
                ./machines/sting/sd-card.nix
              ];
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
