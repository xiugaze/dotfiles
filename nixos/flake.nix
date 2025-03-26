{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [
      # "https://hyprland.cachix.org"
    ];

    extra-trusted-public-keys = [
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

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
      home-manager,
      systems,
      ...
    } @ inputs :
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib; # bring in home-manager library
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});

      pkgsFor = lib.genAttrs (import systems) (
        system:
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
      );
      globalModules = [
        ./modules/base.nix
      ];
    in
    {

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      nixosConfigurations = with nixpkgs.lib; {
        caladan = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = globalModules ++ [
            ./hosts/caladan
          ];
        };
        chapterhouse = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = globalModules ++ [
            ./hosts/chapterhouse
          ];
        };
        heighliner = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = globalModules ++ [
            ./hosts/heighliner
          ];
        };
      };

      homeConfigurations = with home-manager.lib; { 
        "caleb@caladan" = homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/caleb/caladan.nix ];
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "caleb@heighliner" = homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/caleb/heighliner.nix ];
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "caleb@chapterhouse" = homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/caleb/chapterhouse.nix ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
