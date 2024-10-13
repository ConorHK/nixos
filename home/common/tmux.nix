{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shortcut = "t";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    aggressiveResize = true;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      extrakto
      sensible
      session-wizard
      tmux-fzf
      yank
    ];
    extraConfig = ''
            set-window-option -g mode-keys vi
      if-shell "test '\( #{$TMUX_VERSION_MAJOR} -eq 2 -a #{$TMUX_VERSION_MINOR} -ge 4 \)'" 'bind-key -Tcopy-mode-vi v send -X begin-selection; bind-key -Tcopy-mode-vi y send -X copy-selection-and-cancel'
      if-shell '\( #{$TMUX_VERSION_MAJOR} -eq 2 -a #{$TMUX_VERSION_MINOR} -lt 4\) -o #{$TMUX_VERSION_MAJOR} -le 1' 'bind-key -t vi-copy v begin-selection; bind-key -t vi-copy y copy-selection'

      # Rename of pane
      # set-option -g automatic-rename on
      # set-option -g automatic-rename-format '#{pane_current_command}'

      # OSC52 clipboard sharing
      # Ms modifies OSC 52 clipboard handling to work with mosh, see
      # https://gist.github.com/yudai/95b20e3da66df1b066531997f982b57b
      set -ag terminal-overrides ",tmux-256color:Ms=\\E]52;c;%p2%s\\7,xterm*:XT:Ms=\\E]52;c;%p2%s\\7"

      # enable OSC 52 clipboard
      # https://medium.freecodecamp.org/tmux-in-practice-integration-with-system-clipboard-bcd72c62ff7b
      set -g set-clipboard on

      set -g history-limit 50000

      set -g status-keys emacs

      # status bar
      set -g focus-events on
      set -g status-style bg=default
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify left
      set -g status-fg colour7
      set -g status-bg colour235
      set -g status-interval 5
      set -g status-position top
      setw -g window-status-separator " "
      setw -g window-status-format "#[bg=colour241,fg=colour0] #I #[bg=colour241,fg=colour0]#W #[bg=default,fg=colour241]▓░"
      setw -g window-status-current-format "#[bg=colour10,fg=colour0] #I #[bg=colour10,fg=colour0]#W #[bg=default,fg=colour10]▓░"
      set-option -g status-right "#[bg=default,fg=colour237]░▓#[bg=colour237,fg=colour15]#[bg=colour237,fg=colour243] %Y/%m/%d-%u #[fg=colour7]%H%M #[bg=colour243,fg=colour237]▓#[default]"
      set-option -g status-left "#[bg=colour235,fg=colour7] #S "

      # bind -n C-Left select-pane -L
      # bind -n C-Right select-pane -R
      # bind -n C-Up select-pane -U
      # bind -n C-Down select-pane -D
      #
      # bind -n C-h select-pane -L
      # bind -n C-j select-pane -D
      # bind -n C-k select-pane -U
      # bind -n C-l select-pane -R

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind-key -n 'C-Left' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-Down' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-Up' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-Right' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'


      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      bind-key -T copy-mode-vi 'C-Left' select-pane -L
      bind-key -T copy-mode-vi 'C-Down' select-pane -D
      bind-key -T copy-mode-vi 'C-Up' select-pane -U
      bind-key -T copy-mode-vi 'C-Right' select-pane -R

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # split window paths
      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"

      set -g @extrakto_clip_tool "osc-copy"
      set -g @extrakto_clip_tool_run "tmux_osc52"
    '';
  };
}
