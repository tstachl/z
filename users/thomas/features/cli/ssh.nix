{ config, ... }:
let
  inherit (config.programs.gpg) homedir;
in
{
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.xdg.configHome}/gnupg/S.gpg-agent.ssh";
  };

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;

    matchBlocks = {
      thor = {
        hostname = "thor";
        user = "thomas";
      };

      vault = {
        hostname = "vault";
        user = "pi";
      };

      "github.com" = {
        user = "git";
      };
    };
  };
}
