{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;

    historySize = 100000;
    historyFileSize = 100000;
    historyControl = [ "ignoredups" "erasedups" ];

    shellOptions = [
      "autocd"
      "cdspell"
      "dirspell"
      "globstar"
      "histappend"
    ];

    shellAliases = {
      # General
      mv = "mv -i";
      cp = "cp -i";
      rm = "rm -i";
      df = "df -h";
      du = "du -h";
      ll = "ls -la --color=auto";
      grep = "grep --color";

      # Nix dev environments
      nix-tt-mlir = "nix run ~/.dotfiles/tt/tt-mlir";

      # Git
      gs = "git status";
      au = "git add -u; git status";
      o = "git open";
      gd = "git develop";
      gm = "git master";
      gp = "git push";
      tt = "tig";

      # Shell
      sss = "source ~/.bashrc";

      # Tmux
      tmux = "tmux -2 -f ~/.tmux.conf";
      tmux-copy = "tmux save-buffer - | pbcopy";
      tmux-paste = "pbpaste | tmux load-buffer - && tmux paste-buffer";

      # Vim
      vim = "nvim";
    };

    initExtra = ''
      # ------------------------------------
      # Vim mode
      # ------------------------------------
      set -o vi

      # ------------------------------------
      # Prompt settings
      # ------------------------------------
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

      # ------------------------------------
      # SSH-Agent
      # ------------------------------------
      if [ -z "$SSH_AGENT_PID" ] || ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
          ssh-agent > ~/.ssh-agent
          . ~/.ssh-agent
      fi
      ssh-add -l >& /dev/null || ssh-add

      # ------------------------------------
      # Peco functions
      # ------------------------------------
      # Search command history
      function peco-select-history() {
          local cmd=$(history | tac | sed 's/^[ ]*[0-9]*[ ]*//' | grep -v "^ls" | peco --query "$READLINE_LINE")
          if [ -n "$cmd" ]; then
              READLINE_LINE="$cmd"
              READLINE_POINT=${#cmd}
          fi
      }

      # Change directory to ghq repo
      function peco-ghq() {
          local selected_dir=$(ghq list --full-path | peco)
          if [ -n "$selected_dir" ]; then
              cd "$selected_dir"
          fi
      }

      # Git branch checkout
      function peco-git-branch-checkout() {
          local selected_branch=$(git branch -a | peco | tr -d ' ')
          case "$selected_branch" in
              *-\>* )
                  selected_branch=$(echo "$selected_branch" | perl -ne 's/^.*->(.*?)\/(.*)$/\2/;print');;
              remotes* )
                  selected_branch=$(echo "$selected_branch" | perl -ne 's/^.*?remotes\/(.*?)\/(.*)$/\2/;print');;
          esac
          if [ -n "$selected_branch" ]; then
              git checkout "$selected_branch"
          fi
      }

      # Kubernetes context switch
      function peco-kubectx() {
          local selected_ctx=$(kubectx | peco)
          if [ -n "$selected_ctx" ]; then
              kubectx "$selected_ctx"
          fi
      }

      # Peco keybindings (requires bash 4.0+)
      if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
          bind -x '"\C-r": peco-select-history'
          bind -x '"\C-j": peco-ghq'
          bind -x '"\C-b": peco-git-branch-checkout'
          bind -x '"\C-x": peco-kubectx'
      fi

      # ------------------------------------
      # Load local settings
      # ------------------------------------
      [ -f ~/.localrc ] && source ~/.localrc
    '';
  };

  # Peco configuration
  xdg.configFile."peco/config.json".text = builtins.toJSON {
    Keymap = {
      "C-k" = "peco.SelectPrevious";
      "C-j" = "peco.SelectNext";
      "C-g" = "peco.Cancel";
      "C-v" = "peco.SelectNextPage";
    };
  };
}
