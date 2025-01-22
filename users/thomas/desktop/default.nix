{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./fonts.nix
    ./ghostty.nix
    ./syncthing.nix
    ./yubikey.nix
  ];

  home.packages = with pkgs; [ unstable.lmstudio ];
}
