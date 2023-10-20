{ outputs, ... }:
{
  services.zerotier = {
    enable = true;

    authtoken = "${(outputs.lib.readSecret "zerotier")}";

    identity = {
      public = "";
      secret = "";
    };

    networks = {
      "${(outputs.lib.readSecret "stoic_krum")}" = {
        allowManaged = true;
        allowDNS = true;
      };
    };

    controller = {
      enable = true;

      networks = {
        "${(outputs.lib.readSecret "stoic_krum")}" = {
          name = "stoic_krum";
          description = "";

          private = true;
          enableBroadcast = true;

          v4AssignMode = {
            zt = true;
          };

          v6AssignMode = {
            "6plane" = false;
            rfc4193 = false;
            zt = false;
          };

          mtu = 2800;
          multicastLimit = 32;

          routes = [{
            target = "172.25.0.0/16";
            via = null;
          }];

          ipAssignmentPools = [{
            ipRangeStart = "172.25.0.1";
            ipRangeEnd = "172.25.255.254";
          }];

          dns = {
            domain = "t5.st";
            servers = [ "172.25.99.76" ];
          };

          rules = [
            {
              etherType = 2048;
              not = true;
              or = false;
              type = "MATCH_ETHERTYPE";
            }
            {
              etherType = 2054;
              not = true;
              or = false;
              type = "MATCH_ETHERTYPE";
            }
            {
              etherType = 34525;
              not = true;
              or = false;
              type = "MATCH_ETHERTYPE";
            }
            {
              type = "ACTION_DROP";
            }
            {
              type = "ACTION_ACCEPT";
            }
          ];

          capabilities = [];

          tags = [];

          remoteTraceTraget = "7f5d90eb87";
          remoteTraceLevel = 0;
        };
      };
    };
  };
}
