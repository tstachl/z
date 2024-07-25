{
  enterShell = ''
    workspace=$(pwd | rev | cut -d'/' -f1,2 | rev)
    echo "🚀 workspace: $workspace"
  '';
}
