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
    vim 
    gcc
    gnumake

    # basic environment
    zsh
    starship
    tmux

    fzf
    zoxide	# better cd
    eza		# better ls
    fd		# better find
    bat 	# better cat
    ripgrep	# better grep
    tealdeer	# simpler man

    # other
    rsync
    neofetch
    pfetch
    htop
    tree

  ];
}
