{ pkgs, ... }:
{
  imports = [
    # ./agenix.nix
    # ./fish.nix
    # ./gnupg.nix
    ./home-manager.nix
    # ./locale.nix
    ./nix.nix
    # ./openssh.nix
    # ./persist.nix
  ];

  environment = {
    # add terminfo files
    # enableAllTerminfo = true;

    # add important packages
    systemPackages = with pkgs; [
      git # parted TODO: fix for darwin nixos
    ];
  };
}
