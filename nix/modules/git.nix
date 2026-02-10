{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    includes = [
      { path = "~/.gitconfig.local"; }
    ];

    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".direnv"
      ".envrc"
    ];

    settings = {
      user = {
        name = "Kohei Yamaguchi";
        email = "fix7211@gmail.com";
      };

      core = {
        editor = ''vim -c "set fenc=utf-8"'';
      };

      init = {
        defaultBranch = "main";
      };

      diff = {
        colorMoved = "default";
      };

      merge = {
        ff = false;
        conflictstyle = "diff3";
      };

      pull = {
        rebase = true;
      };

      push = {
        default = "simple";
      };

      grep = {
        lineNumber = true;
      };

      ghq = {
        root = "~/src";
      };

      "ghq \"alias\"" = {
        g = "get";
        l = "look";
        ls = "list";
      };

      "remote \"origin\"" = {
        fetch = "+refs/pull/*/head:refs/remotes/origin/pr/*";
      };

      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };

      credential = {
        helper = "store";
      };

      alias = {
        s = "status";
        st = "status";
        ss = "status -s";
        sh = "show";
        so = "remote show origin";

        a = "add";
        ad = "add";
        au = "!git add -u && git status";
        c = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        cmb = "!f () { git commit -m \"$1 ($(git branch -a | grep '^*' | cut -b 3-))\";};f";

        b = "branch -a";
        br = "branch -r";

        o = "open";

        co = "checkout";
        cb = "checkout -b";
        develop = "checkout develop";
        master = "checkout master";

        d = "diff";
        ds = "diff --staged";
        dn = "diff --name-only";
        dm = "diff master";
        d1 = "diff HEAD~";
        d2 = "diff HEAD~~";
        d3 = "diff HEAD~~~";
        d4 = "diff HEAD~~~~";
        d5 = "diff HEAD~~~~~";

        l = "log --graph -n 20 --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(green)- %an, %cr%Creset'";
        ll = "log --stat --abbrev-commit";
        l1 = "log --stat --abbrev-commit -n 1";

        gr = "grep";
        gn = "grep -n";

        p = "push";
        pb = "!git push -u origin $(git branch -a | grep '^*' | cut -b 3-);";
        pom = "push -u origin master";

        td = "!git for-each-ref --sort=taggerdate refs/tags";

        this = "!git init && git add . && git commit -m \"Initial commit\"";
        rr = "!git ls-files -z --deleted | xargs -0 git rm";
        alias = "!git config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\ => \\2/' | sort";
        ignore = "!ignore () { echo $1 >> .gitignore;};ignore";
        now = "rev-parse --abbrev-ref HEAD";
      };
    };
  };

  # Delta configuration (separate from git)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      line-numbers = true;
      side-by-side = true;
    };
  };
}
