{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "setup";
  runtimeInputs = [ pkgs.gptfdisk pkgs.cryptsetup pkgs.zfs pkgs.util-linux ];
  text = builtins.readFile ./setup.sh;
}
