{ inputs, pkgs, ... }:
{
  home.packages = [ pkgs.tmux-cht ];

# - WARNING Neither Tc nor RGB capability set. True colors are disabled. |'termguicolors'| won't work properly.
#   - ADVICE:
#     - Put this in your ~/.tmux.conf and replace XXX by your $TERM outside of tmux:
#       set-option -sa terminal-features ',XXX:RGB'
#     - For older tmux versions use this instead:
#       set-option -ga terminal-overrides ',XXX:Tc'

  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    enable = true;
    escapeTime = 10;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = yank;
        extraConfig = ''
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      }
    ];

    extraConfig = ''
      # split windows on the current path
      unbind %
      unbind '"'
      bind-key %      split-window -h -c '#{pane_current_path}'
      bind-key '"'    split-window -v -c '#{pane_current_path}'

      # resize pane with vim motion keys
      bind -r h resize-pane -L 1
      bind -r l resize-pane -R 1
      bind -r j resize-pane -D 1
      bind -r k resize-pane -U 1

      # Obsidian keybindings
      bind-key o switch-client -T obsidian
      bind-key -T obsidian t display-popup -h 100% -w 100% -x 0% -E "nvim -c 'ObsidianToday' -c 'ZenMode'"
      bind-key -T obsidian d display-popup -h 100% -w 100% -x 0% -E "nvim -c 'ObsidianDailies' -c 'ZenMode'"
      bind-key -T obsidian y display-popup -h 100% -w 100% -x 0% -E "nvim -c 'ObsidianYesterday' -c 'ZenMode'"
      bind-key -T obsidian n display-popup -h 100% -w 100% -x 0% -E "nvim -c 'ObsidianNew' -c 'ZenMode'"

      # - Put this in your ~/.tmux.conf and replace XXX by your $TERM outside of tmux:
      set-option -sa terminal-features ',xterm-256color:RGB'

      ## COLORSCHEME: kanagawa dark
      # taken from gruvbox and changed toLmy needs: https://github.com/egel/tmux-gruvbox/blob/main/tmux-gruvbox-dark.conf
      set-option -g status "on"
      # default statusbar color
      set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1
      # default window title colors
      set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1
      # default window with an activity alert
      set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3
      # active window title colors
      set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1
      # pane border
      set-option -g pane-active-border-style fg=colour250 #fg2
      set-option -g pane-border-style fg=colour237 #bg1
      # message infos
      set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1
      # writing commands inactive
      set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1
      # pane number display
      set-option -g display-panes-active-colour colour250 #fg2
      set-option -g display-panes-colour colour237 #bg1
      # clock
      set-window-option -g clock-mode-colour colour109 #blue
      # bell
      set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg
      # Theme settings mixed with colors (unfortunately, but there is no cleaner way)
      set-option -g status-justify "left"
      set-option -g status-left-style none
      set-option -g status-left-length "80"
      set-option -g status-right-style none
      set-option -g status-right-length "80"
      set-window-option -g window-status-separator ""

      # status bar
      set-option -g status-left "#[bg=colour241,fg=colour248] #S #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
      set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h "

      set-window-option -g window-status-current-format "#[bg=colour214,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold] #W#{?window_zoomed_flag,*Z,} #[bg=colour237,fg=colour214,nobold,noitalics,nounderscore]"
      set-window-option -g window-status-format "#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour223] #I #[bg=colour239,fg=colour223] #W #[bg=colour237,fg=colour239,noitalics]"

      # default layout
      set-hook -g after-new-window 'split-window -h -p 30; split-window -v -p 66; split-window -v -p 50'
    '';
  };
}
