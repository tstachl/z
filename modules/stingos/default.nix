{ config, lib, ... }:

with lib;

let
  cfg = config.stingos;
in

{
  options.stingos = {
    enable = mkEnableOption (mdDoc "StingOS");

    package = mkOption {
      default = pkgs.stingos;
      defaultText = literalExpression "pkgs.stingos";
      type = types.package;
      example = literalExpression "pkgs.stingos-custom";
      description = mdDoc "StingOS package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

  };
}
