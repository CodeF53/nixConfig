{ ... }:

{
  imports = [
    ./btop-panel.nix
    ./cursor.nix
    ./misc.nix
    ./shortcuts.nix
    ./taskbar.nix
  ];
  programs.plasma.enable = true; # https://nix-community.github.io/plasma-manager/options.xhtml
}
