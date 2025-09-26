{ config, pkgs, lib, inputs, ...}: {
  imports = [
    ./global
    # (builtins.fetchurl {
    #   url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
    #   sha256 = "1krclaga358k3swz2n5wbni1b2r7mcxdzr6d7im6b66w3sbpvnb3";
    # })
  ];

  home.stateVersion = lib.mkForce "25.05"; # Please read the comment before changing.
  home.username = lib.mkForce "candreano";
  home.homeDirectory = lib.mkForce "/home/candreano";
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;


  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

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
    nixgl.nixGLIntel
    (config.lib.nixGL.wrap firefox)
    (config.lib.nixGL.wrap ghostty)
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
        g="git";
        ga="git add -A";
        gc="git commit -m";
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

      garbage() {
        nix-collect-garbage --delete-old
      }
      garbageold() {
        nix-collect-garbage --delete-older-than $1
      }
      set bell-style none
    '';
  };
  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';


  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = config.lib.nixGL.wrap pkgs.hyprland;
  #   settings = {
  #     general = {
  #       gaps_in = 0;
  #       gaps_out = 0;
  #       border_size = 20;
  #     };
  #   };
  # };
}

