{ cht-sh
, coreutils
, fzf
, tmux
, writeShellApplication
}: writeShellApplication {
  name = "tmux-cht.sh";
  runtimeInputs = [ cht-sh coreutils fzf tmux ];
  text = ''
    selected=$(cht.sh :list | fzf)
    if [[ -z $selected ]]; then
        exit 0
    fi

    query=""
    if [[ "$selected" != *":"* ]]; then
      read -rp "Enter Query: " query
      query=$(echo "$query" | tr ' ' '+')
    fi

    if [[ -z $query ]]; then
      tmux neww bash -c "${cht-sh}/bin/cht.sh $selected | less"
    else
      tmux neww bash -c "${cht-sh}/bin/cht.sh $selected $query | less"
    fi
  '';
}
