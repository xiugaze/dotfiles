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
    shellInitLast = ''
      enable_transience
    '';
  };

  gtk.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32; # also set by hyprcursor on startup, min available is 32 :(
  };

}
