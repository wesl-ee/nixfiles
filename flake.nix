{
  description = "wesl-ee nixos + darwin + home-manager configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
  let
    nixosHost = hostName: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./modules/system/common.nix
        ./modules/system/cachix.nix
        ./hosts/${hostName}.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.wesl-ee = import ./home/hosts/${hostName}.nix;
        }
      ];
    };
  in {
    nixosConfigurations = {
      divinity = nixosHost "divinity";
      wonder-pop = nixosHost "wonder-pop";
      air2earth = nixosHost "air2earth";
      wind-tempos = nixosHost "wind-tempos";
    };

    darwinConfigurations.particle-arts = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/particle-arts.nix
        {
          nixpkgs.config.allowUnfree = true;
          home-manager.users.wesl-ee = import ./home/hosts/particle-arts.nix;
          users.users.wesl-ee.home = "/Users/wesl-ee";
        }
      ];
    };
  };
}
