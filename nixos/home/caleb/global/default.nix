{ inputs, config, pkgs, ... }:
let 
  shellAliases = {
    cd="z";
    ls="eza --icons";
    lt="eza --tree --icons --level";
    la="eza --icons -lah --git -s type";
    lg="lazygit";
    rsync="rsync -avP";
    pandoc="ENVFS_RESOLVE_ALWAYS=1 pandoc";
  };
in {
  imports = [];

  home.username = "caleb";
  home.homeDirectory = "/home/caleb";

  home.sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.cargo/bin"
  ];

  programs.zathura = {
    enable = true;
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      i = "recolor";
      p = "print";
      mg = "goto top";
      j = "feedkeys \"<C-Down>\"";
      k = "feedkeys \"<C-Up>\"";
      h = "feedkeys \"<C-Left>\"";
      l = "feedkeys \"<C-Right>\"";
    };
    options = {
      selection-clipboard = "clipboard";
    };
  };

  programs.git = {
    enable = true;
    userName = "Caleb Andreano";
    userEmail = "calebandreano@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "master";
        help.autocorrect = "prompt";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      set termguicolors
      set nu rnu 
      set autoindent
      set tabstop=2
      set shiftwidth=2 
      set smarttab
      set softtabstop=2
      set mouse=a
      let mapleader = ";"
      set encoding=UTF-8
      set clipboard=unnamedplus
      nmap <leader>y "+y
      nmap <leader>p "+p
      nmap H ^
      nmap L $
      nmap E ge
      nmap K ~
      vmap < <gv
      vmap > >gv
      :colorscheme catppuccin_mocha
    '';
    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      vim-wayland-clipboard
      catppuccin-vim
    ];
  };

  programs.lf = {
    enable = true;
    keybindings = {
      d = "";
      dd = "delete";
      dD = "dD $IFS=':'; rm -rf $fx";
    };

  };

  programs.zsh = {
    enable = true;
    # defaultKeymap = "vicmd";
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    plugins = with pkgs; [
      {
        name = zsh-vi-mode.pname;
        src = zsh-vi-mode.src;
      }
    ];

    initExtra = ''
      gc() {
        nix-collect-garbage --delete-old
      }
      gco() {
        nix-collect-garbage --delete-older-than $1
      }
      set bell-style none
    '';
    envExtra = ''
      if [ -x /usr/libexec/path_helper ]; then
              PATH="" # <- ADD THIS LINE (right before path_helper call)
              eval `/usr/libexec/path_helper -s`
      fi
    '';
  };

  programs.fish = {
    enable = true;
    functions = {};
    interactiveShellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      set -g fish_greeting ""
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      bind H beginning-of-line
      bind L end-of-line
    '';
    shellAliases = shellAliases;
  };


  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shell = "${pkgs.fish}/bin/fish";
    mouse = true;
    extraConfig = ''
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      unbind '"'
      unbind %

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'

      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      # bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      set -g focus-events on
      set -g status-style bg=default
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify centre

      set -ga update-environment 'KITTY_LISTEN_ON'
    '';
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
