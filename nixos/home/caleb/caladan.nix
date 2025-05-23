{ inputs, lib, pkgs, config, ...}: {

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

  programs.starship = {
    enableTransience = true;
  };

  gtk.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32; # also set by hyprcursor on startup, min available is 32 :(
  };

  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    settings = {
      general = {
        lock_cmd  = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

}
