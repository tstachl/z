{ pkgs, ... }:
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
        "vault.sting.t5.st"= {
          extraConfig = ''
            encode gzip
            tls {
              dns cloudflare ${(builtins.readFile ../../secrets/cloudflare)}
            }
            root * ${pkgs.vaultwarden.webvault}/share/vaultwarden/vault
            reverse_proxy / 127.0.0.1:8000
            file_server
          '';
        };
      };
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vault.sting.t5.st";
        SIGNUPS_ALLOWED = false;
      };
    };
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
