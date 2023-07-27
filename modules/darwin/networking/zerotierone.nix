{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zerotierone;
in
{
  options.services.zerotierone.enable = mkEnableOption (lib.mdDoc "ZeroTierOne");

  options.services.zerotierone.joinNetworks = mkOption {
    default = [];
    example = [ "a8a2c3c10c1a68de" ];
    type = types.listOf types.str;
    description = lib.mdDoc ''
      List of ZeroTier Network IDs to join on startup
    '';
  };

  options.services.zerotierone.port = mkOption {
    default = 9993;
    type = types.port;
    description = lib.mdDoc ''
      Network port used by ZeroTier.
    '';
  };

  # options.services.zerotierone.package = mkOption {
  #   default = pkgs.zerotierone;
  #   defaultText = literalExpression "pkgs.zerotierone";
  #   type = types.package;
  #   description = lib.mdDoc ''
  #     ZeroTier One package to use.
  #   '';
  # };

  config = mkIf cfg.enable {
    launchd.daemons.zerotierone = {
      serviceConfig = {
        Label = "com.zerotier.one";
        UserName = "root";
        ProgramArguments = [ "/Library/Application Support/ZeroTier/One/launch.sh" ];
        WorkingDirectory = "/Library/Application Support/ZeroTier/One";
        StandardOutPath = "/dev/null";
        StandardErrorPath = "/dev/null";
        KeepAlive = true;
      };
    };

      # path = [ cfg.package ];

      # preStart = ''
      #   mkdir -p /var/lib/zerotier-one/networks.d
      #   chmod 700 /var/lib/zerotier-one
      #   chown -R root:root /var/lib/zerotier-one
      # '' + (concatMapStrings (netId: ''
      #   touch "/var/lib/zerotier-one/networks.d/${netId}.conf"
      # '') cfg.joinNetworks);
      # serviceConfig = {
      #   ExecStart = "${cfg.package}/bin/zerotier-one -p${toString cfg.port}";
      # };

    # environment.systemPackages = [ cfg.package ];

    homebrew.casks = [ "zerotier-one" ];
  };
}
