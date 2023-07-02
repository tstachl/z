{ config, lib, ... }:

with lib;

let
  cfg = config.system.rosetta;
in

{
  options = {
    system.rosetta.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Rosetta.";
    };
  };

  config = {
    system.activationScripts.extraActivation.text = optionalString cfg.enable (mkAfter ''
      # enable rosetta
      echo "enable rosetta..." >&2
      softwareupdate --install-rosetta --agree-to-license
    '');
  };
}
