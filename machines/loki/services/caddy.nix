{ config, ... }:
let
  cfg = config.services.caddy;
in
{
  services.caddy = {
    enable = true;
    enableReload = true;
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_TOKEN}
    '';
  };

  systemd.services.caddy.serviceConfig = {
    AmbientCapabilities = "cap_net_bind_service";
    CapabilitiyBoundingSet = "cap_net_bind_service";
    TimeoutStartSec = "5m";
    EnvironmentFile = "/run/secrets/caddy.env";
  };

  sops.secrets."caddy.env" = {
    sopsFile = ../secrets/caddy.env;
    format = "dotenv";
    mode = "0440";
    owner = cfg.user;
    group = cfg.group;
  };
}
