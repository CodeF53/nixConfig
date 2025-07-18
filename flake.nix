{
  inputs = {
    env-toml.url = "file:///home/cassie/nixConfig/env.toml";
    env-toml.flake = false;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    plasma-manager.url = "github:nix-community/plasma-manager";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: { nixosConfigurations.cassietop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hardware-configuration.nix
      ./configuration.nix
      { imports = [ (import ./modules/enviroment-variables.nix { inherit inputs; }) ]; }
      inputs.nix-flatpak.nixosModules.nix-flatpak
      ./modules/flatpak.nix

      home-manager.nixosModules.home-manager { home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.cassie = import ./home.nix;
      }; }
    ];
  }; };
}
