{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    colima
    docker-client
    docker-compose
  ];

  services.colima = {
    enable = true;
    createDockerSocket = true;

    groupMembers = [ "thomas" ];
    architectue = "x86_64";
    extraFlags = [
      "--cpu-type max"
      "--vz-rosetta"
    ];
  };
}
