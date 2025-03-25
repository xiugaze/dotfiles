{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
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

    # my packages
    love-letters.url = "github:xiugaze/love-letters?ref=main";
    andreano-dev.url = "github:xiugaze/andreano.dev";

  };

  outputs = {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-wsl,
      home-manager,
      systems,
      catppuccin,
      rust-overlay,
      love-letters,
      ...
    } @ inputs :
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
      );
      globalModules = [
        # home-manager.nixosModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.users.caleb = {
        #     imports = [
        #       ./home.nix
        #       catppuccin.homeManagerModules.catppuccin
        #     ];
        #   };
        # }
        (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
          }
        )
        ./modules/base.nix
      ];
    in
    {

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      nixosConfigurations = {
        caladan = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit love-letters nixpkgs-unstable; };
          modules = globalModules ++ [
            ./hosts/caladan/configuration.nix
            ./services/love-letters.nix
            catppuccin.nixosModules.catppuccin
          ];
        };
        chapterhouse = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixpkgs-unstable; };
          modules = globalModules ++ [
            ./hosts/chapterhouse/configuration.nix
          ];
        };
        heighliner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
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

      homeConfigurations = { 
        "caleb@heighliner" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/caleb/heighliner.nix ];
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
