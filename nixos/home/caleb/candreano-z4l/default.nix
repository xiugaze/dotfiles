{ config, pkgs, lib, inputs, ...}: 

let 
  wrap = config.lib.nixGL.wrap;
in {
  imports = [
    ../global
    ../modules/neovim.nix
  ];

  home.stateVersion = lib.mkForce "25.05"; # Please read the comment before changing.
  home.username = lib.mkForce "candreano";
  home.homeDirectory = lib.mkForce "/home/candreano";
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    x11.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 24;
  };

  nvim = {
    enable = true;
    lang.python = true;
  };

  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  home.packages = with pkgs; [
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
    just
    nixgl.nixGLIntel
    harper
    ninja
    libqalculate
    flameshot
    feh
    neofetch
    htop
    blueberry
    spotifyd
    pavucontrol
    pasystray
    dunst
    unstable.uv
    unstable.mergiraf
    fuc # fast unix commands
    frangipanni

    # blocked by network security lol
    # rust-bin.stable.latest.default 

    ## gui apps
    (wrap unstable.firefox)
    (wrap zathura)
    (wrap kitty)
    (wrap spotify-qt)
    i3
    unclutter
    # (wrap i3lock)
    dmenu
  ];

  programs.zathura = {
    package = (wrap pkgs.zathura);
  };

  programs.git = lib.mkForce {
    enable = true;
    package = pkgs.git;
    userName = "Caleb Andreano";
    userEmail = "Caleb.Andreano@spacex.com";
    extraConfig = {
      init = {
        help.autocorrect = "prompt";
      };
    };
  };

  programs.starship = {
    enableTransience = true;
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      PATH = "$HOME/bin:$HOME/.local/bin:$PATH";
      TERM = "xterm-256color";
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
        mg="mergiraf";
        fr="frangipanni";
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

  programs.lazygit = {
    enable = true;
    settings = {
      os.editPreset = "neovim";
      os.editAtLine = "nvim +{{line}} {{filename}}";
      os.editAtLineAndWait = "nvim +{{line}} {{filename}}";
      os.edit = "nvim {{filename}}";
    };

  };

  programs.fish = {
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
        mg="mergiraf";
        rm="rmz";
        cp="cpz";
    };
    functions = lib.mkAfter {
      gcm = {
        body = ''
          pushd ~/src/satcode/rocket
          ./tools/format_changes.sh
          popd
          pushd ~/src/satcode/gidney
          ./tools/format_changes.sh
          popd
          git add -A; and git commit -m "$argv[1]"
        '';
      };
    };
  };
  xdg.configFile."fish/completions/bazel.fish".source = ./bazel.fish;

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';
}

