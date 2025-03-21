{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    # mine
    love-letters.url = "github:xiugaze/love-letters?ref=main";
  };

  outputs = inputs@{ 
    nixpkgs, 
    nixpkgs-unstable, 
    nixos-wsl,
    home-manager, 
    catppuccin,   # literally only for gtk theming...
    love-letters, 
    zen-browser,
    rust-overlay,
    ... 
  }: 
  let 
    globalModules = [
      # install home manager globally
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.caleb = {
          imports = [
            ./home.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };
      }
      # everyone gets rust lol
      # docs @ https://github.com/oxalica/rust-overlay
      ({pkgs, ...}: {
        nixpkgs.overlays = [ rust-overlay.overlays.default ];
        environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
      })
      # basic package environment
      ./modules/base.nix
    ];
  in {
    nixosConfigurations = {
      # desktop
      caladan = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = globalModules ++ [
          ./hosts/caladan/configuration.nix
          # ./services/love-letters.nix
          catppuccin.nixosModules.catppuccin
        ];
      };
      # chapterhouse
      chapterhouse = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs-unstable; };
        modules = globalModules ++ [
          ./hosts/chapterhouse/configuration.nix
        ];
      };
      # wsl 
      heighliner = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs-unstable; };
        modules = globalModules ++ [
	  nixos-wsl.nixosModules.default {
	    system.stateVersion = "24.05";
            wsl.enable = true;
	    wsl.defaultUser = "caleb";
	  }
          ./hosts/heighliner/configuration.nix
        ];
      };
    };
}
