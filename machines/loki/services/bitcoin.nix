{ config, inputs, ... }:
let
  nbLib = config.nix-bitcoin.lib;
  srvs = config.services;
in
{
  imports = [
    inputs.nix-bitcoin.nixosModules.default
  ];

  nix-bitcoin = {
    generateSecrets = true;
    operator = {
      enable = true;
      name = "thomas";
    };
  };

  services.bitcoind.enable = true;
  services.electrs.enable = true;
  services.mempool.enable = true;

  environment.persistence."/persist".directories = [
    {
      directory = config.services.bitcoind.dataDir;
      user = config.services.bitcoind.user;
      group = config.services.bitcoind.group;
      mode = "u=rwx,g=rx,o=";
    }
    {
      directory = config.services.electrs.dataDir;
      user = config.services.electrs.user;
      group = config.services.electrs.group;
      mode = "u=rwx,g=rx,o=";
    }
  ];

  services.caddy.virtualHosts."mempool.loki.t5.st".extraConfig = ''
    reverse_proxy ${nbLib.addressWithPort srvs.mempool.frontend.address srvs.mempool.frontend.port}
  '';
}
