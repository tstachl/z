{ outputs, ... }:
{
  services.zerotier = {
    enable = true;
    # zeronsd.enable = true;

    networks = {
      "${(outputs.lib.readSecret "stoic_krum")}" = {
        allowDNS = true;
      };
    };
  };
}
