{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  devenv = pkgs.callPackage ./devenv { };
  setup = pkgs.callPackage ./setup { };
  geekworm-xscript = pkgs.callPackage ./geekworm-xscript.nix { };
  # zerotierone = pkgs.callPackage ./zerotierone { };
}
