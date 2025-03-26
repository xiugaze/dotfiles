{ inputs, pkgs, config, ...}: {

  imports = [
    ./global
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

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
  gtk.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32; # also set by hyprcursor on startup, min available is 32 :(
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "io.gitlab.LibreWolf.desktop";
      "x-scheme-handler/http" = "io.gitlab.LibreWolf.desktop";
      "x-scheme-handler/https" = "io.gitlab.LibreWolf.desktop";
      "x-scheme-handler/about" = "io.gitlab.LibreWolf.desktop";
      "x-scheme-handler/unknown" = "io.gitlab.LibreWolf.desktop";
    };
  };
}
