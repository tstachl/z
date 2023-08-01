{ outputs, ... }:
{
  services.zerotier = {
    enable = true;
    networks = {
      "${(outputs.lib.readSecret "stoic_krum")}" = {};
    };
  };
}
