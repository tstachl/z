{ config, ... }:
let
  inherit (config.home-manager.users.thomas.xdg) configHome;
in
{
  home-manager.users.thomas = {
    home.sessionVariables = {
      SSH_AUTH_SOCK = "${configHome}/gnupg/S.gpg-agent.ssh";
    };

    programs.ssh = {
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';

      matchBlocks = {
        loki = {
         hostname = "192.168.1.169";
          user = "thomas";
          remoteForwards = [{
            bind.address =
              "/run/user/1000/gnupg/d.o6jzqfigwppq1eps4nhng6n5/S.gpg-agent";
            host.address = "/Users/thomas/.config/gnupg/S.gpg-agent.extra";
          }];
        };
      };
    };
  };
}
