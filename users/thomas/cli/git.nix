{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Thomas Stachl";
    userEmail = "i@t5.st";

    signing = {
      gpgPath = "${pkgs.gnupg}/bin/gpg";
      key = "ED5EAAA8E895B23A";
      signByDefault = true;
    };

    aliases = {
      b = "branch";
      bc = "checkout -b";
      bl = "branch -v";
      bL = "branch -av";
      bx = "branch -d";
      bX = "branch -D";
      bm = "branch -m";
      bM = "branch -M";
      bs = "show-branch";
      bS = "show-branch -a";
      co = "checkout";
      co0 = "checkout HEAD --";
      f = "fetch";
      fm = "pull";
      fo = "fetch origin";
      m = "merge";
      mom = "merge origin/master";
      p = "push";
      pa = "push --all";
      pt = "push --tags";
      r = "rebase";
      ra = "rebase --abort";
      rc = "rebase --continue";
      ri = "rebase --interactive";
      rs = "rebase --skip";
      rom = "rebase origin/master";
      c = "commit -v";
      ca = "commit --all -v";
      cm = "commit --message";
      cam = "commit --all --message";
      camend = "commit --amend --reuse-message HEAD";
      cundo = "reset --soft 'HEAD^'";
      cp = "cherry-pick";
      d = "diff          # Diff working dir to index";
      ds = "diff --staged # Diff index to HEAD";
      dc = "diff --staged # Diff index to HEAD";
      dh = "diff HEAD     # Diff working dir and index to HEAD";
      hub = "browse";
      hubd = "compare";
      s = "status";
      a = "add";
      ia = "add";
      ir = "reset";
      l = "log --topo-order --pretty=format:'%C(yellow)%h %C(cyan)%cn %C(blue)%cr%C(reset) %s'";
      ls = "log --topo-order --stat --pretty=format:'%C(bold)%C(yellow)Commit:%C(reset) %C(yellow)%H%C(red)%d%n%C(bold)%C(yellow)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)%C(yellow)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'";
      ld = "log --topo-order --stat --patch --full-diff --pretty=format:'%C(bold)%C(yellow)Commit:%C(reset) %C(yellow)%H%C(red)%d%n%C(bold)%C(yellow)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)%C(yellow)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lga = "log --topo-order --all --graph --pretty=format:'%C(yellow)%h %C(cyan)%cn%C(reset) %s %C(red)%d%C(reset)%n'";
      lm = "log --topo-order --pretty=format:'%s'";
      lh = "shortlog --summary --numbered";
      llf = "fsck --lost-found";
      lg1 = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      re = "remote";
      rel = "remote --verbose";
      rea = "remote add";
      rex = "remote rm";
      rem = "remote rename";
    };

    extraConfig = {
      core = {
        editor = "vim";
        pager = "less -FRSX";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };

      color = {
        grep = "always";
        pager = "true";
        showbranch = "auto";
        ui = "always";

        interactive = {
          error = "red bold";
        };

        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };

        diff = {
          meta = "yellow";
          frag = "magenta";
          old = "red";
          new = "green";
          whitespace = "white reverse";
        };

        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
          branch = "magenta";
        };
      };

      diff.tool = "vimdiff";
      difftool.prompt = "false";
      merge.tool = "vimdiff";
      push.default = "matching";
      pull.rebase = "false";
      init.defaultBranch = "master";

      url = {
        "git@github.com:" = {
          insteadOf = "github:";
        };
      };

      branch = {
        master = {
          remote = "origin";
          merge = "refs/head/master";
        };
      };
    };
  };
}


# [filter "lfs"]
# 	clean = git-lfs clean -- %f
# 	smudge = git-lfs smudge -- %f
# 	process = git-lfs filter-process
# 	required = true
