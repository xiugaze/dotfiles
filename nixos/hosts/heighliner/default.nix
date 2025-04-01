{ config, pkgs, inputs, ... }: 
let 
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = config.nixpkgs.config;
  };
in {
  networking.hostName = "heighliner";
  imports = [
    inputs.nixos-wsl.nixosModules.default {
      system.stateVersion = "24.05";
      wsl.enable = true;
      wsl.defaultUser = "caleb";
    }
    ../../modules/neovim.nix 
    ../../modules/syncthing.nix 
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  programs.fish.enable = true;
  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "storage" "docker" "disk" "dialout" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };


  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  _module.args.unstable = unstable;

  environment.systemPackages = with pkgs; [ 
    python314
    pandoc
    texliveFull
    rust-bin.stable.latest.default 

  ];

  services.openssh.enable = true;

  virtualisation.docker =  {
    enable = true;
  };
}
