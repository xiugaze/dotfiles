{config, pkgs, unstable, ...}: {
  environment.systemPackages = with pkgs; [
    # system
    git
    wget
    lsb-release
    unzip
    p7zip
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
    lazygit

    fzf
    zoxide      # better cd
    eza         # better ls
    fd          # better find
    bat         # better cat
    ripgrep     # better grep
    tealdeer    # simpler man

    # other
    rsync
    neofetch
    pfetch
    htop
    tree

  ];
}
