{ inputs, pkgs, ... }:

{
  imports = [ inputs.eden.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    lutris
    protonup-rs
    (prismlauncher.override {
      additionalLibs = [ ocl-icd khronos-ocl-icd-loader ];
      jdks = [ openjdk25 ];
    })
    dolphin-emu
    # sgdboop
    r2modman
    mangohud
  ];
  programs.eden.enable = true;

  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      nss
      curl
    ];
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;
}
