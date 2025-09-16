{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
  ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.gamemode.enable = true;
}
