{ config, pkgs, inputs, ... }:
let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # add missing dynamic libraries
  ];

  networking.hostName = "heighliner";

  users.users.caleb = {
    shell = pkgs.zsh;
    extraGroups = [ "docker" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };

  imports = [
    ./pkgs-base.nix
    ./pkgs-neovim.nix 
  ];

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
