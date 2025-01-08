{ config, pkgs, ... }:
{
  home.username = "caleb";
  home.homeDirectory = "/home/caleb";
  home.packages = with pkgs; [ posy-cursors ];
  home.sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      PATH = "$PATH:~/bin";
  };

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";
    gtk = {
      enable = true;
      icon.enable = true;
      icon.accent = "lavender";
    };
    zathura = {
      enable = true;
      flavor = "mocha";
    };
  };
  gtk.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32; # also set by hyprcursor on startup, min available is 32 :(
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = ["librewolf.desktop"];
    "x-scheme-handler/https" = ["librewolf.desktop"];
    "text/html" = ["librewolf.desktop"];
  };
  
  programs.git = {
    enable = true;
    userName = "Caleb Andreano";
    userEmail = "calebandreano@gmail.com";
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

  programs.zsh = {
    enable = true;
    defaultKeymap = "vicmd";
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      cd="z";
      ls="eza --icons -h --git";
      l="eza --icons -lah --git";
      dev="nix develop -c zsh";
    };
    initExtra = ''
      gc() {
        nix-collect-garbage --delete-older-than $1
      }
    '';
    #sessionVariables = { };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
