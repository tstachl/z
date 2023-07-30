{ config, lib, name, pkgs, ... }:

with lib;

{
  options = {
    networkId = mkOption {
      default = name;
      example = "d5e04297a16fa690";
      description = mdDoc "The 16-digit network ID.";
      type = types.str;
    };

    zeronsd = mkOption {
      type = with types; submodule (import ./zeronsd-options.nix);
      default = {};
      example = literalExpression ''
        {
          zeronsd = {
            domain = "beyond.corp";
            hosts = '''
              1.1.1.1 cloudflare-dns
            ''';
            token = "iOaQ8HMi7mspJwyWUFAAXUehmjr3UVeb";
            wildcard = true;
          };
        };
      '';
      description = mdDoc ''
        Declarative specifications of ZeroNSD on a by network basis.
      '';
    };

    allowManaged = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc "Allow this network to configure IP addresses and routes?";
      example = true;
    };

    allowGlobal = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Allow configuration of IPs and routes within global (Internet) IP space?";
      example = true;
    };

    allowDefault = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Allow overriding of system default routes for \"full tunnel\" operation?";
      example = true;
    };

    allowDNS = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Allow configuration of DNS for the network?";
      example = true;
    };
  };
}
