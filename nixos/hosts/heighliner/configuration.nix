{ config, pkgs, inputs, nixpkgs-unstable, ... }:
let 
  unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config = config.nixpkgs.config;
  };
in {
  networking.hostName = "heighliner";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  users.users.caleb = {
    isNormalUser = true;
    description = "caleb";
    extraGroups = [ "networkmanager" "wheel" "storage" "docker" "disk" "dialout" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };

  imports = [
    ../../modules/neovim.nix 
    ../../modules/syncthing.nix 
  ];
  _module.args.unstable = unstable;

  environment.systemPackages = with pkgs; [ ];

  services.openssh.enable = true;

  virtualisation.docker =  {
    enable = true;
  };
}
