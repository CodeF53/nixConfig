{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    protonup-rs
    prismlauncher
  ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.gamemode.enable = true;
}
