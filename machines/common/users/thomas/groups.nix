{ config, ... }:
let
  ifExists = groups: builtins.filter (
    group: builtins.hasAttr group config.users.groups
  ) groups;
in
{
  users.users.thomas = {
    extraGroups = [ "wheel" "video" "audio" ] ++ ifExists [
      "network" "wireshark" "i2c" "docker" "podman" "git" "libvirtd" "keys"
    ];
  };
}
