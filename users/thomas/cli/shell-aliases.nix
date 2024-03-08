{
  "..." = "cd ../..";
  "...." = "cd ../../..";

  # NixOS
  snrs = "sudo nixos-rebuild switch --flake .#$(hostname)";

  # Git stuff
  g = "git";
  gco = "git checkout ";
  gcob = "git checkout -b ";
  ghi = "gh issue create --body '' --title ";
}
