{ pkgs, lib, ... }:
let
  homeLocation = with pkgs.stdenv.hostPlatform;
    if isDarwin then "/Users" else "/home";
in
{
  imports = [
    ../../optional/fish.nix
  ];

  users.users.thomas =  {
    home = lib.mkDefault "${homeLocation}/thomas";
    shell = pkgs.fish;
  };

  home-manager.users.thomas = import ../../../../users/thomas;
}
