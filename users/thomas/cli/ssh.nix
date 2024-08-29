{
  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;

    matchBlocks = {
      thor = {
        hostname = "thor";
        user = "thomas";
      };

      "github.com" = {
        user = "git";
      };
    };
  };
}
