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
  ];
  _module.args.unstable = unstable;

  environment.systemPackages = with pkgs; [
    python3
  ];

  services.openssh.enable = true;
  services.syncthing = {
    enable = true;
    user = "caleb";
    dataDir = "/home/caleb/sync/";
    configDir = "/home/caleb/.config/syncthing";
    openDefaultPorts = true;
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  virtualisation.docker =  {
    enable = true;
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 
        8384 22000  # syncthing
      ];
      allowedUDPPorts = [ 
        22000 21027 # syncthing
      ];
    };
  };
}
