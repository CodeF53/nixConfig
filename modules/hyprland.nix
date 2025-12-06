{ pkgs, ... }:

{
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprlauncher
    hyprpaper
    hyprshot
    playerctl
    jq
    hyprpolkitagent
  ];
}
