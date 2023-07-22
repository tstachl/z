# TODO: this is just an example of an init script
{ config, pkgs, ... }:
{
  systemd.services.sting-init = {
    description = "Auto Configure Sting Raspberry Pi";

    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    requires = [ "network-online.target" ];

    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    script = ''
      #!${pkgs.runtimeShell} -eu

      echo "attempting to fetch configuration ..."

      export HOME=/root
      export PATH=${pkgs.lib.makeBinPath [ config.nix.package pkgs.systemd pkgs.gnugrep pkgs.git pkgs.gnutar pkgs.gzip pkgs.gnused config.system.build.nixos-rebuild config.system.build.nixos-generate-config]}:$PATH
      export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels

      # If we start from 0
      # 1. find hard drive
      # 2. format hard drive
      # 3. pull configuration
      # 4. apply configuration

      # If we start from crash
      # 1. find hard drive
      # 2. check and fix hard drive
      # 3. pull configuration
      # 4. apply configuration

      nixos-rebuild switch
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
