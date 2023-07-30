{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.zerotier;

  networks = attrValues cfg.networks;
  mkNetworkConf = network:
    ''
    echo -e "allowManaged=${toString network.allowManaged}
    allowGlobal=${toString network.allowGlobal}
    allowDefault=${toString network.allowDefault}
    allowDNS=${toString network.allowDNS}" \
    > /var/lib/zerotier-one/networks.d/${network.networkId}.local.conf
    '';
in

{

  options.services.zerotier = {
    enable = mkEnableOption (mdDoc "ZeroTier One Agent");

    port = mkOption {
      default = 9993;
      type = types.port;
      description = mdDoc "Network port used by ZeroTier.";
    };

    package = mkOption {
      default = pkgs.zerotierone;
      defaultText = literalExpression "pkgs.zerotierone";
      type = types.package;
      description = mdDoc "ZeroTier One package to use.";
    };

    networks = mkOption {
      type = with types; attrsOf (submodule (import ./network-options.nix));
      default = {};
      example = literalExpression ''
        {
          "d5e04297a16fa690" = {
            allowManaged = 1;
            allowGlobal = 0;
            allowDefault = 0;
            allowDNS = 0;
          };
        };
      '';
      description = mdDoc ''
        Declarative specifications of networks connected to by ZeroTier One.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # TODO: find out if this works on nix-darwin
    (if (builtins.hasAttr "launchd" options) then {
      # TODO: add darwin options
    } else {
      environment.systemPackages = [ cfg.package ];

      systemd.services.zerotier = {
        description = "ZeroTier One";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "network-online.target" ];
        wants = [ "network-online.target" ];

        preStart = ''
          mkdir -p /var/lib/zerotier-one/networks.d
          chmod 700 /var/lib/zerotier-one
          chown -R root:root /var/lib/zerotier-one
        '' + (concatMapStringsSep "\n" mkNetworkConf networks);

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/zerotier-one -p${toString cfg.port}";
          Restart = "always";
          KillMode = "process";
          TimeoutStopSec = 5;
        };
      };

      # ZeroTier does not issue DHCP leases, but some strangers might...
      networking.dhcpcd.denyInterfaces = [ "zt*" ];
      # ZeroTier receives UDP transmissions
      networking.firewall.allowedUDPPorts = [ cfg.port ];

      # Prevent systemd from potentially changing the MAC address
      systemd.network.links."50-zerotier" = {
        matchConfig = {
          OriginalName = "zt*";
        };
        linkConfig = {
          AutoNegotiation = false;
          MACAddressPolicy = "none";
        };
      };
    })

  ]);
}
