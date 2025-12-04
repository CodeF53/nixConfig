{ inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./misc.nix
    ./shortcuts.nix
    ./startup.nix
    ./taskbar.nix
  ];
  programs.plasma.enable = true; # https://nix-community.github.io/plasma-manager/options.xhtml
}
