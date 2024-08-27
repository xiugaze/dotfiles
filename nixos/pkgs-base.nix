{config, pkgs, ...}: 
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  environment.systemPackages = with pkgs; [
    # system
    git
    wget
    unzip
    binutils
    openssh

    # developer tools
    vim 
    gcc
    gnumake
    ripgrep
    fzf
    zsh
    starship
    tmux
    tree

    # other
    rsync
    neofetch
    pfetch
    htop
  ];
}
