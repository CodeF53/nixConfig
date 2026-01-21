{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.beammp-launcher
    (
      let
        libraryPath = with pkgs; lib.makeLibraryPath [
          fontconfig
          freetype
          glib
          nss
          nspr
          dbus
          atk
          cups
          libdrm
          xorg.libX11
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          libgbm
          xorg.libxcb
          libxkbcommon
          pango
          cairo
          alsa-lib
          vulkan-loader
          libglvnd
        ];
      in
      pkgs.writeScriptBin "launch-beamng" ''
        #!/usr/bin/env ${pkgs.lib.getExe pkgs.bash}

        set -euo pipefail

        export LD_LIBRARY_PATH="${libraryPath}:$LD_LIBRARY_PATH"

        cmd=$(printf '%s ' "$@")
        cmd=$(sed -E 's#/[^ ]*/steam-launch-wrapper -- .* ([^ ]*/proton waitforexitandrun)##' <<< "$cmd")
        cmd=$(sed -E 's#BeamNG\.drive\.exe#BinLinux/BeamNG.drive.x64#' <<< "$cmd")

        $cmd
      ''
    )
  ];
  
  # beammp has broken certs...
  security.pki.certificateFiles = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "beammp-cert";
      nativeBuildInputs = [ pkgs.curl ];
      builder = (
        pkgs.writeScript "beammp-cert-builder" "curl -w %{certs} https://auth.beammp.com/userlogin -k > $out"
      );
      outputHash = "sha256-IjPAWvD57XCoCqJ7cq5/Jr2w4Y17iFW7ws6/xMpDLBU=";
    })
  ];
}