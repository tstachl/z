{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./hardware.nix

    ../common/global
    ../common/optional/gnupg.nix
    ../common/optional/locale.nix
    ../common/optional/fish.nix
    ../common/optional/nixos.nix
    ../common/optional/openssh.nix
    ../common/optional/sops.nix
    ../common/optional/tailscale.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # impermanence
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      "/var/log"
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

  networking.hostId = "575e22bc";
  networking.hostName = "thor";
  time.timeZone = "America/Santiago";
  system.stateVersion = "24.05";
}
