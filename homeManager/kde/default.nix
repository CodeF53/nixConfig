{ inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./cursor.nix
    ./misc.nix
    ./shortcuts.nix
    ./startup.nix
    ./taskbar.nix
  ];
  programs.plasma.enable = true; # https://nix-community.github.io/plasma-manager/options.xhtml
}
