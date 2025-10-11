{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    protonup-rs
    prismlauncher
    dolphin-emu
    inputs.eden.packages.${pkgs.system}.default
    sgdboop
  ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.gamemode.enable = true;
}
