{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.colima;
  user = config.users.users."colima";
  group = config.users.groups."_colima";
in
{
  options.services.colima = {
    enable = mkEnableOption "Container runtimes on macOS";

    createDockerSocket = mkEnableOption ''
      Create a symlink from Colima's socket to /var/run/docker.sock, and set
      it's permissions so that users part of the _colima group can use it.
    '';

    package = mkOption {
      type = types.package;
      default = pkgs.colima;
      defaultText = literalExpression "pkgs.colima";
    };

    logFile = mkOption {
      type = types.path;
      default = "/var/log/colima.log";
      description = "Stdout and sterr of the colima process.";
    };

    groupMembers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users that should be added to the colima group.";
    };

    runtime = mkOption {
      type = types.enum [
        "docker"
        "containerd"
        "incus"
      ];
      default = "docker";
      description = "The runtime to use with Colima.";
    };

    architectue = mkOption {
      type = types.enum [
        "x86_64"
        "aarch64"
        "host"
      ];
      default = "host";
      description = "The architecture to use for the Colima virtual machine.";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--vz-rosetta" ];
      description = "Extra commandline options to pass to the colima start command.";
    };

    vmType = mkOption {
      type = types.enum [
        "qemu"
        "vz"
      ];
      default = "vz";
      description = "Virtual machine type to use with Colima.";
    };
  };

  config = mkIf cfg.enable {
    launchd.daemons.colima-create-docker-socket-and-set-permissions = {
      script = ''
        until [ -S ${user.home}/.colima/default/docker.sock ]
        do
          sleep 5
        done

        chmod g+rw ${user.home}/.colima/default/docker.sock
        ln -sf ${user.home}/.colima/default/docker.sock /var/run/docker.sock
      '';

      serviceConfig.RunAtLoad = cfg.createDockerSocket;
      serviceConfig.EnvironmentVariables.PATH = "/usr/bin:/bin:/usr/sbin:/sbin";
    };

    launchd.daemons.colima = {
      script =
        concatStringsSep " " [
          "exec"
          (getExe cfg.package)
          "start"
          "--foreground"
          "--runtime ${cfg.runtime}"
          "--arch ${cfg.architectue}"
          "--vm-type ${cfg.vmType}"
        ]
        + escapeShellArgs cfg.extraFlags;

      serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
      serviceConfig.StandardErrorPath = cfg.logFile;
      serviceConfig.StandardOutPath = cfg.logFile;
      serviceConfig.GroupName = group.name;
      serviceConfig.UserName = user.name;
      serviceConfig.WorkingDirectory = user.home;
      serviceConfig.EnvironmentVariables = {
        PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        COLIMA_HOME = "${user.home}/.colima";
      };
    };

    system.activationScripts.preActivation.text = ''
      touch '${cfg.logFile}'
      chown ${toString user.uid}:${toString user.gid} '${cfg.logFile}'
    '';

    users.knownGroups = [
      "colima"
      "_colima"
    ];
    users.knownUsers = [
      "colima"
      "_colima"
    ];

    users.users."colima" = {
      uid = mkDefault 400;
      gid = mkDefault group.gid;
      home = mkDefault "/var/lib/colima";
      # The username isn't allowed to have an underscore in its name, the VM
      # will fail to start with the following error otherwise
      #   > "[hostagent] identifier \"_colima\" must match ^[A-Za-z0-9]+(?:[._-](?:[A-Za-z0-9]+))*$: invalid argument" fields.level=fatal
      name = "colima";
      createHome = true;
      shell = "/bin/bash";
      description = "System user for Colima";
    };

    users.groups."_colima" = {
      gid = mkDefault 32002;
      name = "_colima";
      description = "System group for Colima";
    };

    users.groups."_colima".members = cfg.groupMembers;
  };

  meta.maintainers = [
    lib.maintainers.bryanhonof or "bryanhonof"
  ];
}
