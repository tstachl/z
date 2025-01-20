{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    colima
    docker-client
    docker-compose
  ];

  services.colima.enable = true;
  services.colima.createDockerSocket = true;
}
