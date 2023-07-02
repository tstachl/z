{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking;

  remoteLogin = optionalString (cfg.remoteLogin) ''
    systemsetup -setremotelogin on
  '';

in

{
  options = {

    networking.remoteLogin = mkEnableOption "remote login";

  };

  config = {

    system.activationScripts.networking.text = mkIf cfg.remoteLogin (mkAfter ''
      # enable remote login
      echo "enabling remote login..." >&2

      ${remoteLogin}
    '');

  };
}
