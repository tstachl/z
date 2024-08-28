{ lib, pkgs, ... }:
{
  home.sessionPath = [ "$HOME/.docker/bin" ];

  programs.fish = {
    # TODO: check if certain named arguments are set and default if not
    interactiveShellInit = lib.mkAfter ''
      function spotdl -d "Run spotdl in the current directory with my defaults"
        $HOME/.docker/bin/docker run --rm \
          -v $(pwd):/music \
          spotdl/spotify-downloader \
          --format="m4a" \
          --bitrate="320k" \
          --output="{artist}/{album}/{track-number} - {title}" \
          $argv
      end
    '';
  };
}
