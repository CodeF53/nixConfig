{ pkgs, ... }:

{
  imports = [
    ./fetch.nix
    ./fish.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    fzf
    micro
    bat
    eza
    lazygit
    fd
    ripgrep
    nh
  ];

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
}
