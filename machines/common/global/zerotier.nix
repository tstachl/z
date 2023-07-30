{ outputs, ... }:
{
  services.zerotier = {
    enable = true;
    # zeronsd.enable = true;

    networks = {
      "${(outputs.lib.readSecret "stoic_krum")}" = {
        allowDNS = true;
        zeronsd = {
          enable = true;
          domain = "t5.local";
          hosts = ''
            1.1.1.1 cloudflare-dns
          '';
          token = "${(outputs.lib.readSecret "zerotier")}";
          wildcard = true;
        };
      };
    };
  };
}
