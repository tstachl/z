{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.geekworm-xscript;
in
{
  imports = [
    ./fan.nix
  ];

  options = {
    hardware.geekworm-xscript = {
      package = mkOption {
        type = types.package;
        default = pkgs.geekworm-xscript;
        defaultText = literalExpression "pkgs.geekworm-xscript";
        example = literalExpression "pkgs.geekworm-xscript-custom";
        description = lib.mdDoc ''
          Which geekworm-xscript package to use.
        '';
      };
    };
  };
}
