{ lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = import ./shell-aliases.nix;

    interactiveShellInit = lib.mkAfter ''
      function setup -d "Setup GPG dirs"
        gpgconf --list-dirs
        mkdir -p /run/user/1000/gnupg/d.o6jzqfigwppq1eps4nhng6n5
        gpgconf --list-dirs
        exit
      end

      function repos -d "Jump to the Workspace directory"
        set loc ~/Workspace
        set target $loc/$argv[1]

        if not test -d $target
          set repo (string split "/" $argv[1])

          if not test -d $loc/$repo[1]
            echo "creating directory ..."
            mkdir $loc/$repo[1]
          end

          cd $loc/$repo[1]
          git clone git@github.com:$argv[1]
        end

        if test -d $target
          cd $target
        end
      end

      function d -d "Develop on the given repository"
        set loc ~/Workspace
        set target $loc/$argv[1]

        if not test -d $target
          set repo (string split "/" $argv[1])

          if not test -d $loc/$repo[1]
            echo "creating directory ..."
            mkdir $loc/$repo[1]
          end

          cd $loc/$repo[1]
          git clone git@github.com:$argv[1]
        end

        if test -d $target
          cd $target
          nvim .
        end
      end
    '';
  };
}
