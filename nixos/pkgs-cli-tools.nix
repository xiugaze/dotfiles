{config, pkgs, ...}: 
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  environment.systemPackages = with pkgs; [
    bat
    eza
    ripgrep
    fd
    tealdeer
    zoxide
    glow
  ];
}
