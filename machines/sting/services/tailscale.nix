{ outputs, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = "/etc/tailscale_key";
    permitCertUid = "caddy";
  };

  # TODO(@tstachl): needs to be handled differently
  environment.etc.tailscale_key.text = outputs.lib.readSecret "tailscale";
}
