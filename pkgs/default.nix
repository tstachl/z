{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  caddy = pkgs.callPackage ./caddy.nix { };
  devenv = pkgs.callPackage ./devenv { };
  setup = pkgs.callPackage ./setup { };
  geekworm-xscript = pkgs.callPackage ./geekworm-xscript.nix { };
  # zerotierone = pkgs.callPackage ./zerotierone { };
  zeronsd = pkgs.callPackage ./zeronsd.nix {};
}
