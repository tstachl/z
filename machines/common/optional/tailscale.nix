{ lib, options, pkgs, ... }:

with lib;

{
  config = {
    services.tailscale.enable = true;
    services.tailscale.package = pkgs.unstable.tailscale;
  } // optionalAttrs (builtins.hasAttr "firewall" options.networking) {
    networking.firewall.interfaces.tailscale0.allowedTCPPortRanges = [
      { from = 0; to = 65535; }
    ];
  };
}
