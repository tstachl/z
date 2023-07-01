{ ... }:
{
  # programs.gnupg.agent.enable = true;

  # systemd.user.sockets.gpg-agent = {
  #   listenStreams = [
  #     "" # unset
  #     "%h/.config/gnupg/S.gpg-agent"
  #   ];
  # };
}
