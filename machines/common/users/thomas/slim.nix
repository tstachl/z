{ pkgs, lib, ... }:
let
  homeLocation = with pkgs.stdenv.hostPlatform;
    if isDarwin then "/Users" else "/home";
in
{
  imports = [
    ../../optional/fish.nix
  ];

  environment.shells = [ pkgs.fish ];

  users.users.thomas =  {
    home = lib.mkDefault "${homeLocation}/thomas";
    shell = pkgs.fish;
  };

  # home-manager.users.thomas = import ../../../../users/thomas/slim.nix;
}
