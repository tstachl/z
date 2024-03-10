{ lib, ... }:
{
  # services.nginx.virtualHosts.test = {
  #   serverName = "sting.taild019.ts.net";
  #
  #   locations."/" = {
  #     root = "/var/www/sting";
  #   };
  #
  #   extraConfig = ''
  #     auth_pam  "Password Required";
  #     auth_pam_service_name "nginx";
  #   '';
  # };

  services.caddy.virtualHosts.test = {
    hostName = "sting.taild019.ts.net";
    extraConfig = ''
      root * /var/www/sting
      file_server
    '';
  };

  system.activationScripts.makeBlogDir = lib.stringAfter [ "var" ] ''
    mkdir -p /var/www/sting
    echo "<h1>Hello, World!</h1>" > /var/www/sting/index.html
  '';

  services.caddy.virtualHosts.othertest = {
    hostName = "test.sting.taild019.ts.net";
    extraConfig = ''
      root * /var/www/test
      file_server
    '';
  };

  system.activationScripts.makeTestDir = lib.stringAfter [ "var" ] ''
    mkdir -p /var/www/test
    echo "<h1>Hello, Test!</h1>" > /var/www/test/index.html
  '';
}
