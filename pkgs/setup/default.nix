{ writeShellApplication }:
writeShellApplication {
  name = "setup";
  text = builtins.readFile ./setup.sh;
}
