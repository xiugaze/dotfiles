{config, pkgs, unstable, ...}: {
  environment.systemPackages = with pkgs; [
    # system
    git
    wget
    lsb-release # linux standard base
    zip
    unzip
    p7zip

    binutils
    openssh
    vim 
    gcc
    gnumake
    psmisc

    # basic environment
    zsh
    starship
    lf
    zellij
    tmux
    lazygit
    just

    fzf
    zoxide
    eza
    fd
    bat
    ripgrep
    tealdeer

    # other
    rsync
    neofetch
    pfetch
    htop
    tree
  ];
}
