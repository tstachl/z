{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  caddy = pkgs.callPackage ./caddy.nix {};
  devenv = pkgs.callPackage ./devenv {};
  setup = pkgs.callPackage ./setup {};
  geekworm-xscript = pkgs.callPackage ./geekworm-xscript.nix {};
  zeronsd = pkgs.callPackage ./zerotier/zeronsd.nix {};
  zerotier-systemd-manager = pkgs.callPackage ./zerotier/zerotier-systemd-manager.nix {};
  # zerotierone = pkgs.callPackage ./zerotierone { };
}
