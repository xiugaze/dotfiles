{ config, pkgs, ... }:
{
  home.username = "caleb";
  home.homeDirectory = "/home/caleb";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor

  # Packages that should be installed to the user profile.

  home.packages = with pkgs; [ ];

  home.sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      PATH = "$PATH:~/bin";
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 18;
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Caleb Andreano";
    userEmail = "calebandreano@gmail.com";
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
    };
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
