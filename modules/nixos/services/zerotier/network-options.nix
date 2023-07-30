{ cfg }:
{ config, lib, name, ... }:

let
  inherit (lib) mdDoc mkOption types;
in

{
  options = {
    networkId = mkOption {
      default = name;
      example = "d5e04297a16fa690";
      description = mdDoc "The 16-digit network ID.";
      type = types.str;
    };

    allowManaged = mkOption {
      default = true;
      example = true;
      description = mdDoc "Allow this network to configure IP addresses and routes?";
      type = types.bool;
    };

    allowGlobal = mkOption {
      default = false;
      example = true;
      description = mdDoc "Allow configuration of IPs and routes within global (Internet) IP space?";
      type = types.bool;
    };

    allowDefault = mkOption {
      default = false;
      example = true;
      description = mdDoc "Allow overriding of system default routes for \"full tunnel\" operation?";
      type = types.bool;
    };

    allowDNS = mkOption {
      default = false;
      example = true;
      description = mdDoc "Allow configuration of DNS for the network?";
      type = types.bool;
    };
  };
}
