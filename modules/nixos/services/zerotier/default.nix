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
    echo -e "allowManaged=${if network.allowManaged then "1" else "0"}
    allowGlobal=${if network.allowGlobal then "1" else "0"}
    allowDefault=${if network.allowDefault then "1" else "0"}
    allowDNS=${if network.allowDNS then "1" else "0"}" \
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

    zeronsd.package = mkOption {
      default = pkgs.zeronsd;
      defaultText = literalExpression "pkgs.zeronsd";
      type = types.package;
      description = mdDoc "ZeroNSD package to use.";
    };

    systemd-manager.package = mkOption {
      default = pkgs.zerotier-systemd-manager;
      defaultText = literalExpression "pkgs.zerotier-systemd-manager";
      type = types.package;
      description = mdDoc "ZeroTier Systemd Manager package to use.";
    };

    networks = mkOption {
      type = with types; attrsOf (submodule (import ./network-options.nix));
      default = {};
      example = literalExpression ''
        {
          "d5e04297a16fa690" = {
            allowManaged = 1;
            allowDNS = 1;
          };
        };
      '';
      description = mdDoc ''
        Declarative specifications of networks connected to by ZeroTier One.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.package ];

      systemd.services.zerotier-one = {
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
          # LoadCredential=zerotiertoken:/var/lib/zerotier-one/token
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
    }

    (mkIf (any (n: n.zeronsd.enable) networks) {
      environment.systemPackages = [ cfg.zeronsd.package cfg.systemd-manager.package ];

      systemd.timers.zerotier-systemd-manager = {
        description = "Update zerotier per-interface DNS settings";

        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnStartupSec = "1min";
          OnUnitInactiveSec = "1min";
        };
      };

      systemd.services = mkMerge [
        {
          zerotier-systemd-manager = {
            description = "Update zerotier per-interface DNS settings";

            requires = [ "zerotier-one.service" ];
            after = [ "zerotier-one.service" ];

            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${cfg.systemd-manager.package}/bin/zerotier-systemd-manager";
            };
          };
        }

        (mapAttrs' (name: value:
          nameValuePair ("zeronsd-" + name) ({
            description = "zeronsd for network ${name}";

            wantedBy = [ "multi-user.target" ];
            after = [ "zerotier-one.service" ];
            requires = [ "zerotier-one.service" ];

            serviceConfig = {
              Type = "simple";

              ExecStart = concatStringsSep " " (
                [ "${cfg.zeronsd.package}/bin/zeronsd" "start" ] ++

                (filter (el: el != "") (flatten (mapAttrsToList (n: v:
                  if n == "token" then [ "-t" "${pkgs.writeTextDir "token" v}/token" ]
                  else if n == "domain" then [ "-d" v ]
                  else if n == "wildcard" && v == true then "-w"
                  else if n == "hosts" && v != "" then [ "-f" "${pkgs.writeTextDir "hosts" v}/hosts"]
                  else if n == "log_level" then [ "-l" v ]
                  else ""
                ) value.zeronsd) ++ [ name ]))
              );

              TimeoutStopSec = 30;
              Restart = "always";
            };
          })
        ) (filterAttrs (n: v: v.zeronsd.enable) cfg.networks))
      ];
    })
  ]);
}
