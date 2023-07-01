{ pkgs }:
{
  devenv = pkgs.callPackage ./devenv { };
  setup = pkgs.callPackage ./setup { };
}
