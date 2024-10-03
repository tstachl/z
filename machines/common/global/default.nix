{ pkgs, ... }:
{
  imports = [
    ./home-manager.nix
    ./nix.nix
  ];

  environment = {
    # add terminfo files
    # enableAllTerminfo = true;

    # add important packages
    systemPackages = with pkgs; [
      git
      ripgrep
      jq
    ];
  };
}
