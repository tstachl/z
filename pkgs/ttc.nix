{ coreutils
, ffmpeg
, writeShellApplication
}: writeShellApplication {
  name = "ttc.sh";
  runtimeInputs = [ coreutils ffmpeg ];
  text = ''
    file=$(echo "$1" | rev | cut -c11- | rev)
    echo "Combining ..."
    ${ffmpeg}/bin/ffmpeg -i "$file Video.mp4" -i "$file Audio.mp4" "$file.mp4"
    echo "Deleting ..."
    rm "$file Video.mp4"
    rm "$file Audio.mp4"
    echo "Done!"
  '';
}
