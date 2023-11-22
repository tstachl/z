{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  caddy = pkgs.callPackage ./caddy.nix {};
  devenv = pkgs.callPackage ./devenv {};
  drizzle-kit = pkgs.callPackage ./drizzle-kit {};
  geekworm-xscript = pkgs.callPackage ./geekworm-xscript.nix {};
  libsql = pkgs.callPackage ./libsql.nix {};
  # nextdns = pkgs.callPackage ./nextdns.nix {};
  setup = pkgs.callPackage ./setup {};
  tmux-cht = pkgs.callPackage ./tmux-cht.nix {};
  ttc = pkgs.callPackage ./ttc.nix {};
  hardtime-nvim = pkgs.callPackage ./hardtime-nvim.nix {};
  zeronsd = pkgs.callPackage ./zerotier/zeronsd.nix {};
  zerotier-systemd-manager = pkgs.callPackage ./zerotier/zerotier-systemd-manager.nix {};
  # zerotierone = pkgs.callPackage ./zerotierone { };
}
