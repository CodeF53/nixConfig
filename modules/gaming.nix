{ inputs, pkgs, ... }:

{
  imports = [ inputs.eden.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    lutris
    protontricks
    protonup-rs
    prismlauncher
    dolphin-emu
    sgdboop
    beammp-launcher
  ];
  programs.eden.enable = true;
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      nss
      curl
    ];
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
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
