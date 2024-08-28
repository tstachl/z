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
}
