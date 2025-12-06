{ pkgs, ... }:

{
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprlauncher
    playerctl
    jq
    hyprpolkitagent
  ];
}
