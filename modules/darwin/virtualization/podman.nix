{ config, lib, pkgs, ... }:
let
  cfg = config.virtualisation.podman;
  json = pkgs.formats.json { };

  inherit (lib) mkOption types;

  podmanPackage = (pkgs.podman.override {
    extraPackages = cfg.extraPackages
      # setuid shadow
      ++ [ "/run/wrappers" ];
  });

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommand "${podmanPackage.pname}-docker-compat-${podmanPackage.version}"
    {
      outputs = [ "out" "man" ];
      inherit (podmanPackage) meta;
    } ''
    mkdir -p $out/bin
    ln -s ${podmanPackage}/bin/podman $out/bin/docker

    mkdir -p $man/share/man/man1
    for f in ${podmanPackage.man}/share/man/man1/*; do
      basename=$(basename $f | sed s/podman/docker/g)
      ln -s $f $man/share/man/man1/$basename
    done
  '';

in
{

  options.virtualisation.podman = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          This option enables Podman, a daemonless container engine for
          developing, managing, and running OCI Containers on your Linux System.

          It is a drop-in replacement for the {command}`docker` command.
        '';
      };

    dockerSocket.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Make the Podman socket available in place of the Docker socket, so
        Docker tools can find the Podman socket.

        Podman implements the Docker API.

        Users must be in the `podman` group in order to connect. As
        with Docker, members of this group can gain root access.
      '';
    };

    dockerCompat = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Create an alias mapping {command}`docker` to {command}`podman`.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = lib.literalExpression ''
        [
          pkgs.gvisor
        ]
      '';
      description = lib.mdDoc ''
        Extra packages to be installed in the Podman wrapper.
      '';
    };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to periodically prune Podman resources. If enabled, a
          systemd timer will run `podman system prune -f`
          as specified by the `dates` option.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--all" ];
        description = lib.mdDoc ''
          Any additional flags passed to {command}`podman system prune`.
        '';
      };

      dates = mkOption {
        default = { Weekday = 0; Hour = 0; Minute = 0; };
        type = types.str;
        description = lib.mdDoc ''
          Specification (in the format described by
          {manpage}`launchd.StartCalendarInterval(7)`) of the time at
          which the prune will occur.
        '';
      };
    };

    package = lib.mkOption {
      type = types.package;
      default = podmanPackage;
      internal = true;
      description = lib.mdDoc ''
        The final Podman package (including extra packages).
      '';
    };

    defaultNetwork.settings = lib.mkOption {
      type = json.type;
      default = { };
      example = lib.literalExpression "{ dns_enabled = true; }";
      description = lib.mdDoc ''
        Settings for podman's default network.
      '';
    };
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = [ pkgs.qemu cfg.package ]
        ++ lib.optional cfg.dockerCompat dockerCompat;

      # https://github.com/containers/podman/blob/097cc6eb6dd8e598c0e8676d21267b4edb11e144/docs/tutorials/basic_networking.md#default-network
      environment.etc."containers/networks/podman.json" = lib.mkIf (cfg.defaultNetwork.settings != { }) {
        source = json.generate "podman.json" ({
          dns_enabled = false;
          driver = "bridge";
          id = "0000000000000000000000000000000000000000000000000000000000000000";
          internal = false;
          ipam_options = { driver = "host-local"; };
          ipv6_enabled = false;
          name = "podman";
          network_interface = "podman0";
          subnets = [{ gateway = "10.88.0.1"; subnet = "10.88.0.0/16"; }];
        } // cfg.defaultNetwork.settings);
      };

      # TODO: do we need to add this?
      virtualisation.containers = {
        enable = true; # Enable common /etc/containers configuration
        # containersConf.settings = {
        #   network.network_backend = "netavark";
        # };
      };

      launchd.user.agents.podman-prune = {
        serviceConfig.Label = "io.podman.podman-prune.agent";

        script = ''
          ${cfg.package}/bin/podman system prune -f ${toString cfg.autoPrune.flags}
        '';

        serviceConfig.StartCalendarInterval =
          lib.optional cfg.autoPrune.enable cfg.autoPrune.dates;
      };
    };
}
