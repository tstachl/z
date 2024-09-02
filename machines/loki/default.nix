{ inputs, pkgs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./hardware.nix

    ../common/global
    ../common/optional/gnupg.nix
    ../common/optional/fish.nix
    ../common/optional/nixos.nix
    ../common/optional/openssh.nix
    ../common/optional/sops.nix
    ../common/optional/tailscale.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix

    ./services/bitcoin.nix
    ./services/caddy.nix
    ./services/vaultwarden.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [ btop ];

  # impermanence
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
      "/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  networking.hostName = "loki";
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  users.mutableUsers = false;

  system.stateVersion = "24.05";
}
