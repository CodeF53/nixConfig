{
  inputs = {
    env-toml.url = "file:///home/cassie/nixConfig/env.toml";
    env-toml.flake = false;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    plasma-manager.url = "github:nix-community/plasma-manager";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      homeConfig = host: {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          inherit host;
        };
        users.cassie = import ./home.nix;
      };
    in
    {
      # laptop
      nixosConfigurations.cassietop = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          host = "cassietop";
          inherit inputs;
        };
        modules = [
          ./hosts/cassietop/hardware-configuration.nix
          ./configuration.nix
          { imports = [ (import ./modules/enviroment-variables.nix { inherit inputs; }) ]; }
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./modules/flatpak.nix
          ./modules/dev.nix
          ./modules/gaming.nix
          home-manager.nixosModules.home-manager
          { home-manager = homeConfig specialArgs.host; }
        ];
      };
      nixosConfigurations.cassiebox = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          host = "cassietop";
          inherit inputs;
        };
        modules = [
          ./hosts/cassiebox/hardware-configuration.nix
          ./configuration.nix
          { imports = [ (import ./modules/enviroment-variables.nix { inherit inputs; }) ]; }
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./modules/flatpak.nix
          ./modules/dev.nix
          ./modules/gaming.nix
          home-manager.nixosModules.home-manager
          { home-manager = homeConfig specialArgs.host; }
        ];
      };
    };
}
