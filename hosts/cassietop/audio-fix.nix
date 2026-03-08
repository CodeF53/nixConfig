{ lib, pkgs, ... }:

let
  # magic bs to wake up amp
  wakeScript = pkgs.writeShellScriptBin "asus-amp-wake" ''
    DEVICE="/dev/snd/hwC1D0"
    while [ ! -c "$DEVICE" ]; do
      sleep 1
    done
    sleep 10
    HDA_VERB="${lib.getExe' pkgs.alsa-tools "hda-verb"}"
    "$HDA_VERB" "$DEVICE" 0x20 0x500 0x1b
    "$HDA_VERB" "$DEVICE" 0x20 0x477 0x4a4b
    "$HDA_VERB" "$DEVICE" 0x20 0x500 0xf
    "$HDA_VERB" "$DEVICE" 0x20 0x477 0x74
  '';
in
{
  environment.systemPackages = [ pkgs.alsa-tools ];
  systemd.services.asus-amp-wake = {
    description = "Wake up ASUS ALC294 Speaker Amplifier";
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe wakeScript}";
      User = "root";
    };
  };
  powerManagement.resumeCommands = ''
    ${lib.getExe wakeScript} &
  '';
}
