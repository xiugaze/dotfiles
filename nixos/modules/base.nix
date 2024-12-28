{config, pkgs, ...}: 
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  environment.systemPackages = with pkgs; [
    # system
    git
    wget
    lsb-release
    unzip
    binutils
    openssh
    vim 
    gcc
    gnumake
    just

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
