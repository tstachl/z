{ outputs, pkgs, ... }:
{
  imports = [
    ./hardware.nix

    ../common/global
    ../common/optional/fish.nix
    ../common/optional/nixos.nix
    ../common/optional/openssh.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix
  ];

  # stingos = {
  #   enable = true;
  #   apps = {
  #     vaultwarden.enable = true;
  #   };
  # };

  ### BEGIN
  services = {
    caddy = {
      enable = true;

      globalConfig = ''
        default_bind 172.25.60.56
      '';

      virtualHosts = {
        "vault.sting.t5.st:443"= {
          extraConfig = ''
            tls {
              dns cloudflare ${(outputs.lib.readSecret ../../secrets/cloudflare)}
            }

            encode gzip

            header / {
              # Enable HTTP Strict Transport Security (HSTS)
              Strict-Transport-Security "max-age=31536000;"
              # Enable cross-site filter (XSS) and tell browser to block detected attacks
              X-XSS-Protection "0"
              # Disallow the site to be rendered within a frame (clickjacking protection)
              X-Frame-Options "DENY"
              # Prevent search engines from indexing (optional)
              X-Robots-Tag "noindex, nofollow"
              # Disallow sniffing of X-Content-Type-Options
              X-Content-Type-Options "nosniff"
              # Server name removing
              -Server
              # Remove X-Powered-By though this shouldn't be an issue, better opsec to remove
              -X-Powered-By
              # Remove Last-Modified because etag is the same and is as effective
              -Last-Modified
            }

            reverse_proxy 127.0.0.1:8000 {
              header_up X-Real-IP {remote_host}
            }
          '';
        };
      };
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vault.sting.t5.st";
        SIGNUPS_ALLOWED = false;
        YUBICO_CLIENT_ID = (outputs.lib.readSecret ../../secrets/yubico_client_id);
        YUBICO_SECRET_KEY = (outputs.lib.readSecret ../../secrets/yubico_secret_key);
      };
    };
  };

  networking.firewall.interfaces.ztuga2ekfj = {
    allowedTCPPorts = [ 80 443 ];
  };

  systemd.services.caddy.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ];
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ];
  };
  ### END

  networking.hostName = "sting";

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
