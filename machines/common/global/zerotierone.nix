{
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      builtins.exec [ "gpg" "--decrypt" "./secrets/tailscale.gpg" ]
    ];
  };
}
