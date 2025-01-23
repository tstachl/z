{
  description = "more modular configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:tstachl/mynixvim/master";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, darwin, devenv, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin"
      ];
    in
    {
      lib = {
        readSecret = (secret:
          nixpkgs.lib.removeSuffix "\n"
            (builtins.readFile "${self}/secrets/${secret}")
        );
      };

      templates = {
        basic = {
          path = ./templates/basic;
          description = "a basic template to get started";
        };
      };

      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; } // {
          # example = self.nixosConfigurations.example.config.system.build.vm;
        }
      );

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        modgud = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/modgud ];
        };
      };

      darwinConfigurations = {
        meili = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
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

      devShells = forAllSystems(system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [ ./devenv.nix ];
          };
        }
      );
    };
}
