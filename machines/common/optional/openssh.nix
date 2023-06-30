{ outputs, config, lib, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  # programs.ssh.knownHostsFiles = [
  #   ../../../keys/github.keys
  #   ../../../keys/thor.keys
  #   ../../../keys/penguin.keys
  #   ../../../keys/vault.keys
  # ];

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
