{ writeShellApplication
}: writeShellApplication {
  name = "m4b-organize";
  text = ''
    echo "Working ..."
    for filename in ./*.m4b; do
      author=$(xattr -p com.apple.iBooks.author#S "$filename" | cut -f1 -d",")
      title=$(xattr -p com.apple.iBooks.title#S "$filename")

      if [ ! -d "./$author/$title" ]; then
        mkdir -p "./$author/$title"
      fi

      mv "$filename" "./$author/$title/"
    done
    echo "Done!"
  '';
}
