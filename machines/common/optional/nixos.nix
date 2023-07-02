{ inputs, outputs, ... }:
{
  imports = [
    outputs.nixosModules
    inputs.home-manager.nixosModules.home-manager
  ];
}
