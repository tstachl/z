# This module manages the terminfo database
# and its integration in the system.
{ config, lib, pkgs, ... }:

with lib;

{

  options.environment.enableAllTerminfo = with lib; mkOption {
    default = false;
    type = types.bool;
    description = lib.mdDoc ''
      Whether to install all terminfo outputs
    '';
  };

  config = {

    # can be generated with: filter (drv: (builtins.tryEval (drv ? terminfo)).value) (attrValues pkgs)
    environment.systemPackages = mkIf config.environment.enableAllTerminfo (map (x: x.terminfo) (with pkgs; [
      alacritty
      foot
      kitty
      mtm
      rxvt-unicode-unwrapped
      rxvt-unicode-unwrapped-emoji
      termite
      wezterm
    ]));

    environment.pathsToLink = [
      "/share/terminfo"
    ];

    environment.etc.terminfo = {
      source = "${config.system.path}/share/terminfo";
    };

    environment.variables = {
      TERMINFO_DIRS = [ "/share/terminfo" ];
    };

    environment.extraInit = ''

      # reset TERM with new TERMINFO available (if any)
      export TERM=$TERM
    '';
  };
}
