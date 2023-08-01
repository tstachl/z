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

    ./vaultwarden.nix
  ];

  ### beafon start
  systemd.services.nextdns-updater = {
    description = "Updates NextDNS with current IP";

    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.curl}/bin/curl -sL ${outputs.lib.readSecret "nextdns-ip-update"}";
    };
  };

  systemd.timers.nextdns-updater = {
    description = "Update NextDNS with current IP";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnStartupSec = "1min";
      OnUnitInactiveSec = "1min";
    };
  };
  ### beafon end

  networking.hostName = "sting";

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  services.openssh.enable = true;
  users.mutableUsers = false;

  system.stateVersion = "23.05";
}
