{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "setup";
  runtimeInputs = [ pkgs.cryptsetup pkgs.zfs pkgs.parted pkgs.util-linux ];
  text = builtins.readFile ./setup.sh;
}
