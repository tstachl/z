{ config, ... }:
let
  domain = "vault.loki.t5.st";
  user = config.users.users.vaultwarden.name;
  group = config.users.groups.vaultwarden.name;
in
{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/backup/vaultwarden";
    environmentFile = "/run/secrets/vaultwarden.env";
    config = {
      DOMAIN = "https://${domain}";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };

  sops.secrets."vaultwarden.env" = {
    sopsFile = ../secrets/vaultwarden.env;
    format = "dotenv";
    owner = user;
    group = group;
  };

  environment.persistence."/persist".directories = [
    {
      directory = "/var/backup/vaultwarden";
      user = user;
      group = group;
      mode = "u=rwx,g=rx,o=";
    }
  ];

  services.caddy.virtualHosts."${domain}".extraConfig = ''
    reverse_proxy localhost:8222
  '';
}
