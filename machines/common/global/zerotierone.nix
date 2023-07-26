{
  # TODO: make this work for DARWIN
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      (builtins.readFile ../../../secrets/stoic_krum)
    ];
  };
}
