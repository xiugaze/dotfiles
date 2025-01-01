{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    go-test-server.url = "path:./go-test-server";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, go-test-server, ... }: 
    {
    nixosConfigurations = {
      caladan = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit go-test-server; };
        modules = [
          ./hosts/caladan/configuration.nix
          ./modules/go-test-server.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.caleb = import ./home.nix;
          }
        ];
      };
    };
  };
}
