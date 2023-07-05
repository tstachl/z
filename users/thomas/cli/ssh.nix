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

      vault = {
        hostname = "vault";
        user = "pi";
      };

      "github.com" = {
        user = "git";
      };
    };
  };
}
