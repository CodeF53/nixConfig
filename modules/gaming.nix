{ inputs, pkgs, ... }:

let
  beammp-nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/Andy3153/nixpkgs/archive/5ff896c0dd8a558da5bffbe0c16bc7d6a8a0747d.tar.gz";
    sha256 = "sha256:1a3k1v1xgp3yqxl7bjb03qpiirywsm54d9n2srfd14i5p0m70bkd";
  }) { inherit (pkgs) system; };
in
{
  imports = [ inputs.eden.nixosModules.default ];
  environment.systemPackages = with pkgs; [
    lutris
    protonup-rs
    prismlauncher
    dolphin-emu
    sgdboop
    beammp-nixpkgs.beammp-launcher
  ];
  programs.eden.enable = true;
  programs.steam = {
    enable = true;
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
