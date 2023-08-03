{
  description = "rust-toolchain";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustVersion = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        rustPlatform = pkgs.mkRustPlatform {
          cargo = rustVersion;
          rustc = rustVersion;
        };

        meta = (builtins.fromTOML (builtins.readFile ./Cargo.toml));

        rustPackage = rustPlatform.buildRustPackage {
          pname = meta.name;
          version = meta.version;
          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;
        };
      in
      with pkgs;
      {
        defaultPackage = rustPackage;

        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            rust
          ];
        };
      }
    );
}
