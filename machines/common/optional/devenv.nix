{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.devenv.packages.${system}.devenv
  ];
}
