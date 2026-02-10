{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
    };

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
      nix-tt-mlir = "nix run ~/dotfiles/tt/tt-mlir";

      # Git
      gs = "git status";
      au = "git add -u; git status";
      o = "git open";
      gd = "git develop";
      gm = "git master";
      gp = "git push";
      tt = "tig";

      # Shell
      sss = "source ~/.zshrc";

      # Tmux
      tmux = "tmux -2 -f ~/.tmux.conf";
      tmux-copy = "tmux save-buffer - | pbcopy";
      tmux-paste = "pbpaste | tmux load-buffer - && tmux paste-buffer";

      # Vim
      vim = "nvim";
    };

    initContent = lib.mkMerge [
      # First: vim mode binding
      (lib.mkBefore ''
        # Link vim mode
        bindkey -v
      '')

      # Main configuration
      ''
        # ------------------------------------
        # Completion settings
        # ------------------------------------
        fpath=(/usr/local/share/zsh/functions ''${fpath})

        zstyle ':completion:*' verbose yes
        zstyle ':completion:*:descriptions' format '%B%d%b'
        zstyle ':completion:*:default' menu select=1
        zstyle ':completion:*' list-colors '''

        setopt list_packed

        # ------------------------------------
        # History search
        # ------------------------------------
        autoload history-search-end
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end history-search-end
        bindkey "^P" history-beginning-search-backward-end
        bindkey "^N" history-beginning-search-forward-end

        # ------------------------------------
        # Directory navigation
        # ------------------------------------
        setopt auto_cd
        setopt auto_pushd
        setopt pushd_ignore_dups

        # ------------------------------------
        # Correct miss typing command
        # ------------------------------------
        setopt correct

        # ------------------------------------
        # Prompt settings
        # ------------------------------------
        setopt prompt_subst
        setopt prompt_percent
        setopt transient_rprompt

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
            local tac
            if which tac > /dev/null; then
                tac="tac"
            else
                tac="tail -r"
            fi
            BUFFER=$(history -n 1 | \
                            grep -v "ls" | \
                            eval $tac | \
                            peco --query "$LBUFFER")
            CURSOR=$#BUFFER
            zle clear-screen
        }
        zle -N peco-select-history

        # Change directory to ghq repo
        function peco-ghq() {
            local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
            if [ -n "$selected_dir" ]; then
                BUFFER="cd ''${selected_dir}"
                zle accept-line
            fi
            zle clear-screen
        }
        zle -N peco-ghq

        # Git branch checkout
        function peco-git-branch-checkout () {
            local selected_branch_name="$(git branch -a | peco | tr -d ' ')"
                case "$selected_branch_name" in
                        *-\>* )
                            selected_branch_name="$(echo ''${selected_branch_name} | perl -ne 's/^.*->(.*?)\/(.*)$/\2/;print')";;
                        remotes* )
                            selected_branch_name="$(echo ''${selected_branch_name} | perl -ne 's/^.*?remotes\/(.*?)\/(.*)$/\2/;print')";;
                esac
                if [ -n "$selected_branch_name" ]; then
                    BUFFER="git checkout ''${selected_branch_name}"
                    zle accept-line
                fi
                zle clear-screen
        }
        zle -N peco-git-branch-checkout

        # Kubernetes context switch
        function peco-kubectx() {
            local selected_ctx=$(kubectx | peco --query "$LBUFFER")
            if [ -n "$selected_ctx" ]; then
                BUFFER="kubectx ''${selected_ctx}"
                zle accept-line
            fi
            zle clear-screen
        }
        zle -N peco-kubectx

        # Peco keybindings
        bindkey '^r' peco-select-history
        bindkey '^j' peco-ghq
        bindkey '^b' peco-git-branch-checkout
        bindkey '^x' peco-kubectx

        # ------------------------------------
        # Load local settings
        # ------------------------------------
        [ -f ~/.localrc ] && source ~/.localrc
      ''
    ];
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
