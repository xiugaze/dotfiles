{ pkgs, lib, ...}: {
  imports = [./global];

  home.stateVersion = lib.mkForce "25.05"; # Please read the comment before changing.
  home.username = lib.mkForce "candreano";
  home.homeDirectory = lib.mkForce "/home/candreano";
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;


  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    neovim
    vscode
    starship
    lazygit
    fzf
    ripgrep
    fd
    eza
    zoxide
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    firefox
    zathura
    harper
  ];

  programs.git = lib.mkForce {
    enable = true;
    userName = "Caleb Andreano";
    userEmail = "caleb.andreano@spacex.com";
    extraConfig = {
      init = {
        help.autocorrect = "prompt";
      };
    };
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      PATH = "$HOME/bin:$HOME/.local/bin:$PATH";
    };

    shellAliases = {
        cd="z";
        ls="eza --icons";
        lt="eza --tree --icons --level";
        la="eza --icons -lah --git -s type";
        lg="lazygit";
        gid="z ~/src/satcode/gidney";
        roc="z ~/src/satcode/rocket";
        rsync="rsync -avP";
    };
    initExtra = ''
      ta() {
        bazel test //...
      }
      gcm() {
        pushd ~/src/satcode/rocket
        ./tools/format_changes.sh
        popd
        pushd ~/src/satcode/gidney
        ./tools/format_changes.sh
        popd
        git add -A && git commit -m "$1"
      }
      gcf() {
        pushd ~/src/satcode/rocket
        ./tools/format_changes.sh
        popd
        pushd ~/src/satcode/gidney
        ./tools/format_changes.sh
        popd
        local ticket="''$(git rev-parse --abbrev-ref HEAD | grep -oE 'SATSW-[0-9]+')"
        git add -A && git commit -m "''$ticket: $1"
      }

      smoke() {
        pushd ~/src/satcode/payload
        version=$1
        kae=$( [[ "$version" == *"4"* ]] && echo "kae" || echo "ka" )
        build="//missions/starlink/manifests/gateway:gateway.load.''${kae}gwnet1.''${kae}gw_v''${version}p0.smoketest"
        bazel build --config=gateway --config=devel $build
        popd
      }

      gc() {
        nix-collect-garbage --delete-old
      }
      gco() {
        nix-collect-garbage --delete-older-than $1
      }
      set bell-style none
    '';
  };


}

