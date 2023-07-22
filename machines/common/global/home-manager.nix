{ pkgs, inputs, outputs, ... }:
let
  # TODO: figure this thing out
  home-manager-module = with pkgs.stdenv;
    if isDarwin
      then inputs.home-manager.darwinModules.home-manager
      else inputs.home-manager.nixosModules.home-manager;
in
{
  # imports = [ home-manager-module ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; inherit outputs; };
  };
}
