{ config, pkgs, ... }:
let
  inherit (config.xdg) configHome;
in
{
  home.sessionVariables = {
    GNUPGHOME = "${configHome}/gnupg";
  };

  programs.gpg = {
    enable = true;
    homedir = "${configHome}/gnupg";

    publicKeys = [{
      source = pkgs.fetchurl {
        url = "https://keys.openpgp.org/vks/v1/by-fingerprint/7A53D4C6B481F7711588D34FDE749C31D060A160";
        sha256 = "c4I7c+mZVOJpm54aOhIJQtAXAhBQZPnyp4LHEzuH09w=";
      };
      trust = 5;
    }];
  };
}
