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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    eden = {
      url = "github:grantimatter/eden-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rootchat = {
      url = "github:CodeF53/rootchat-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
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

      commonModules = [
        stylix.nixosModules.stylix
        ./configuration.nix
        ./modules/wayland-session.nix
        ./modules/hyprland.nix
        ./modules/theme.nix
        ./modules/environment-variables.nix
        inputs.nix-flatpak.nixosModules.nix-flatpak
        ./modules/flatpak.nix
        ./modules/dev.nix
        ./modules/gaming.nix
        ./modules/controller-nonsense.nix
        ./modules/yt-dlp.nix
        home-manager.nixosModules.home-manager
      ];
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
          { home-manager = homeConfig specialArgs.host; }
        ]
        ++ commonModules;
      };

      # desktop
      nixosConfigurations.cassiebox = nixpkgs.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          host = "cassiebox";
          inherit inputs;
        };
        modules = [
          ./hosts/cassiebox/hardware-configuration.nix
          ./hosts/cassiebox/nvidia.nix
          ./hosts/cassiebox/swap.nix
          ./hosts/cassiebox/disable-motherboard-bluetooth.nix
          ./hosts/cassiebox/disable-useless-audio.nix
          ./hosts/cassiebox/fix-brightness-control.nix
          { home-manager = homeConfig specialArgs.host; }
        ]
        ++ commonModules;
      };
    };
}
