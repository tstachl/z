{ coreutils
, ffmpeg
, writeShellApplication
}: writeShellApplication {
  name = "ttc.sh";
  runtimeInputs = [ coreutils ffmpeg ];
  text = ''
    echo $1
  '';
}
