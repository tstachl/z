{
  description = "more modular configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin"
      ];
    in
    rec {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        simple = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/simple ];
        };

        sting = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/sting ];
          # get all the apps for sting and load them as modules
          # modules = map (file: "${./modules/sting}/${file}")
          #   (builtins.attrNames (builtins.readDir ./modules/sting));
        };

        sdcard = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            ./machines/sting/sd-card.nix
          ];
        };
      };

      darwinConfigurations = {
        meili = darwin.lib.darwinSystem {
          # inherit pkgs; # TODO: check if we need this
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/meili ];
        };
      };

      # homeConfigurations = {
      #   thomas = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     extraSpecialArgs = { inherit inputs; inherit (self) outputs; };

      #     modules = [ ./users/thomas ];
      #   };
      # };
    };
}
