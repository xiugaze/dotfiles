{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    love-letters.url = "github:xiugaze/love-letters?ref=main";
  };

  outputs = inputs@{ 
    nixpkgs, 
    nixpkgs-unstable, 
    home-manager, 
    catppuccin,
    love-letters, ... }: {
    nixosConfigurations = {
      caladan = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit love-letters; };
        modules = [
          ./hosts/caladan/configuration.nix
          ./services/love-letters.nix

          catppuccin.nixosModules.catppuccin
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
        ];
      };
    };
  };
}
