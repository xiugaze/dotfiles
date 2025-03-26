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

  gtk.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32; # also set by hyprcursor on startup, min available is 32 :(
  };

}
