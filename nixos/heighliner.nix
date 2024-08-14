{ config, pkgs, inputs, ... }:
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add missing dynamic libraries
  ];

  networking.hostName = "heighliner";

  users.users.caleb = {
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };

  imports = [
    ./pkgs-base.nix
    ./pkgs-neovim.nix 
  ];

  environment.systemPackages = with pkgs; [
     tmux
     python3
     lf
     luajitPackages.magick
     texlive.combined.scheme-full
     zathura
     starship
  ];

  services.openssh.enable = true;
}
