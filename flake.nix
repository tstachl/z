{
  description = "more modular configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:tstachl/mynixvim/master";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:mic92/sops-nix";
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
        rust-toolchain = {
          path = ./templates/rust-toolchain;
          description = "a rust toolchain template";
        };

        basic = {
          path = ./templates/basic;
          description = "a basic template to get started";
        };
      };

      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; } // {
          simpleVM = self.nixosConfigurations.simple.config.system.build.vm;
          odinSD = self.nixosConfigurations.odin-sdcard.config.system.build.sdImage;
          odinImage = self.nixosConfigurations.odin-sdcard.config.system.build.diskoImagesScript;
        }
      );

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        loki = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/loki ];
        };

        simple = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/simple ];
        };

        sting = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/sting ];
        };

        stingos-installer = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/sting/installer.nix ];
        };

        thor = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/thor ];
        };

        modgud = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/modgud ];
        };

        odin-sdcard = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit outputs; };
          modules = [ ./machines/odin/sdcard.nix ];
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
