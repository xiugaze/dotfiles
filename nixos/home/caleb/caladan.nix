{ inputs, pkgs, config, ...}: {

  imports = [
    ./global
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  xdg.dataFile."scripts/hyprland-bitwarden-resize.sh".source =
    (import ./global/bitwarden-resize.nix pkgs);

  home.packages = with pkgs; [ 
    posy-cursors
  ];

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

  programs.fish = {
    enable = true;
    shellInitLast = ''
      enable_transience
    '';
  };

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
    };
    options = {
      selection-clipboard = "clipboard";
    };
  };
  gtk.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32; # also set by hyprcursor on startup, min available is 32 :(
  };

}
