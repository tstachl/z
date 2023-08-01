{ pkgs, outputs, ... }:
{
  imports = [
    ./hardware.nix

    ../common/global
    ../common/optional/gnupg.nix
    ../common/optional/fish.nix
    ../common/optional/nixos.nix
    ../common/optional/openssh.nix
    ../common/optional/podman.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix
  ];

  services.zerotier = {
    enable = true;
    networks = {
      "${(outputs.lib.readSecret "stoic_krum")}" = {
        allowDNS = true;
        zeronsd = {
          enable = true;
          hosts = ''
            1.1.1.1 cloudflare-dns
          '';
          domain = "t5.st";
          token = "${outputs.lib.readSecret "zerotier"}";
          wildcard = true;
        };
      };
    };
  };

  environment.systemPackages = [ pkgs.dig ];

  networking.hostName = "simple";

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
