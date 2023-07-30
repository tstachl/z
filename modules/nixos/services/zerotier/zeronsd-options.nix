{ config, lib, ... }:

with lib;

{
  options = {
    enable = mkEnableOption (mdDoc "ZeroNSD");

    domain = mkOption {
      type = types.str;
      description = mdDoc "TLD to use for hostnames.";
      example = "beyond.corp";
    };

    hosts = mkOption {
      default = "";
      type = types.lines;
      description = mdDoc "An additional list of hosts in /etc/hosts format.";
      example = literalExpression ''
        '''
          1.1.1.1 cloudflare-dns
        '''
      '';
    };

    token = mkOption {
      default = "";
      type = types.str;
      description = mdDoc "The ZeroTier Central token.";
      example = "iOaQ8HMi7mspJwyWUFAAXUehmjr3UVeb";
    };

    wildcard = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Wildcard all names in Central to point at the respective member's
        IP address(es).
      '';
      example = true;
    };
  };
}
