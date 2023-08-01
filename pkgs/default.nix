{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  caddy = pkgs.callPackage ./caddy.nix {};
  devenv = pkgs.callPackage ./devenv {};
  geekworm-xscript = pkgs.callPackage ./geekworm-xscript.nix {};
  setup = pkgs.callPackage ./setup {};
  zeronsd = pkgs.callPackage ./zerotier/zeronsd.nix {};
  zerotier-systemd-manager = pkgs.callPackage ./zerotier/zerotier-systemd-manager.nix {};
  # zerotierone = pkgs.callPackage ./zerotierone { };
}
