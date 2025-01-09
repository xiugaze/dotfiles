{ config, pkgs, inputs, nixpkgs-unstable, ... }:
let 
  unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config = config.nixpkgs.config;
  };
in {
  networking.hostName = "heighliner";
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
  ];
  _module.args.unstable = unstable;

  environment.systemPackages = with pkgs; [
    python3
    jdk
    mysql84
    go
    kubectl 
    minikube
    mcrcon
    apacheHttpd
  ];

  services.openssh.enable = true;
  virtualisation.docker =  {
    enable = true;
  };
}
