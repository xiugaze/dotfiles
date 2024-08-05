{config, pkgs, ...}: 
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  environment.systemPackages = with pkgs; [
     git
     vim 
     wget
     unzip
     gcc
     gnumake
     ripgrep
     binutils
     neofetch
     pfetch
     htop
     openssh
  ];
}
