{config, pkgs, unstable, ...}: {
  environment.systemPackages = with pkgs; [
    git
    wget
    lsb-release
    zip
    unzip
    p7zip

    binutils
    openssh
    vim 
    gcc
    gnumake
    psmisc

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

    rsync
    neofetch
    pfetch
    htop
    tree
    dconf
  ];
}
