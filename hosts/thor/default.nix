{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../common/systemd-boot/efi.nix
  ];

  networking.hostId = "575e22bc";
  networking.hostName = "thor";

  time.timeZone = "America/Santiago";
  system.stateVersion = "22.11";
}
