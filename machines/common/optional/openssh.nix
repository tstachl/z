{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
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
  security.pam.sshAgentAuth.enable = true;
}
