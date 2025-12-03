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
    sgdboop
    beammp-launcher
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

  # beammp has broken certs...
  security.pki.certificateFiles = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "beammp-cert";
      nativeBuildInputs = [ pkgs.curl ];
      builder = (
        pkgs.writeScript "beammp-cert-builder" "curl -w %{certs} https://auth.beammp.com/userlogin -k > $out"
      );
      outputHash = "sha256-8qyV7wLQBcpNUKasJFRb5BuPD87Orbpy3E5KFeWAkr0=";
    })
  ];
}
