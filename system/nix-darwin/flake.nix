{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };
  outputs = inputs @ { self, ... }: let
    nixpkgsConfig = {
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations = let
      inherit (inputs.nix-darwin.lib) darwinSystem;
      inherit (inputs.nix-homebrew.darwinModules) nix-homebrew;
      inherit (inputs.home-manager.darwinModules) home-manager;
    in {
      particle-arts = darwinSystem {
        system = "aarch64-darwin";
 
        specialArgs = { inherit inputs; };
 
        modules = [
          # nix-homebrew
          home-manager
          ./hosts/particle-arts/configuration.nix
          {
            nixpkgs = nixpkgsConfig;
 
            # home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;
            home-manager.users.wesl-ee = import ../../home/hosts/particle-arts.nix;
            users.users.wesl-ee.home = "/Users/wesl-ee";
          }
        ];
      };
    };
  };
}
