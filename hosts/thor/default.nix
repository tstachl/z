{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostid = "575e22bc";
    hostName = "thor";
  };

  time.timeZone = "America/Santiago";
  system.stateVerion = "22.11";
}
