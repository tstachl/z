{
  services.vaultwarden.enable = true;

  # services.nginx.virtualHosts.vaultwarden = {
  #   listen = [
  #     # listen 443 ssl http2;
  #     # listen [::]:443 ssl http2;
  #     { addr = "0.0.0.0"; port = 443; ssl = true; }
  #   ];
  #
  #   serverName = "sting";
  #
  #   locations."/" = {
  #     proxyPass = "http://127.0.0.1:8222";
  #     extraConfig = ''
  #       proxy_set_header Host $host;
  #       proxy_set_header X-Real-IP $remote_addr;
  #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #       proxy_set_header X-Forwarded-Proto $scheme;
  #     '';
  #   };
  #
  #   extraConfig = ''
  #     auth_pam  "Password Required";
  #     auth_pam_service_name "nginx";
  #   '';
  # };
}
