{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    historyLimit = 100000;
    escapeTime = 1;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";

    extraConfig = ''
      # Pane base index
      setw -g pane-base-index 1

      # Reload config
      bind r source-file ~/.tmux.conf \; display "Reloaded!"

      # Send C-a to application
      bind C-a send-prefix

      # Split panes
      bind | split-window -h
      bind - split-window -v

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Vim-style pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Terminal overrides
      set -g terminal-overrides 'xterm*:smcup@:rmcup@'

      # Status bar colors
      set -g status-style fg=white,bg=black
      set -g status-bg colour232

      # Window list colors
      setw -g window-status-style fg=cyan,bg=default,dim
      setw -g window-status-current-style fg=white

      # Pane border colors
      set -g pane-border-style fg=green,bg=black
      set -g pane-active-border-style fg=white,bg=yellow

      # Command line colors
      set -g message-style fg=white,bg=black,bright

      # Status bar configuration
      set -g status-left-length 40
      set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
      set -g status-right "#[fg=cyan][%Y-%m-%d(%a) %H:%M]"
      set -g status-right-length 150

      # Refresh interval
      set -g status-interval 60

      # Center window list
      set -g status-justify centre

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on

      # Status bar position
      set -g status-position bottom

      # Copy mode settings
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "pbcopy"
    '';
  };
}
