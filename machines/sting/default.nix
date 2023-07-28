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

  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "vault.t5.st"= {
          extraConfig = ''
            encode gzip
            tls {
              dns cloudflare ${(builtins.readFile ../../secrets/cloudflare)}
            }
            root /usr
            proxy / 127.0.0.1:8222
          '';
        };
      };
    };

    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "vault.t5.st";
        SIGNUPS_ALLOWED = false;
      };
    };
  };

  networking.hostName = "sting";

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
