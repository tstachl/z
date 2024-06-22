{
  "..." = "cd ../..";
  "...." = "cd ../../..";

  # NixOS
  snrs = "sudo nixos-rebuild switch --flake .#$(hostname)";

  # Git stuff
  g = "git";
  gco = "git checkout ";
  gcob = "git checkout -b ";
  ghic = "gh issue create --body '' ";

  bun = "docker run --rm -itp 3000:3000 -v $(pwd):/app -w /app oven/bun $argv";
}
