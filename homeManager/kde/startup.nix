{ pkgs, host, ... }:

let
  outputMap = {
    cassiebox = "HDMI-A-2";
    cassietop = "DP-3";
  };
  output = "--output-name=${outputMap.${host}}";
in
{
  programs.plasma.startup.startupScript = {
    equibop = {
      priority = 2;
      text = "${pkgs.equibop}/bin/equibop --start-minimized & disown";
      runAlways = true;
    };
    qbittorrent = {
      priority = 4;
      # you have to configure with the gui to start in tray, see https://github.com/qbittorrent/qbittorrent/issues/23318
      text = "${pkgs.qbittorrent}/bin/qbittorrent & disown";
      runAlways = true;
    };
    steam = {
      priority = 6;
      text = "${pkgs.steam}/bin/steam -silent & disown";
      runAlways = true;
    };
    signal = {
      priority = 7;
      text = "${pkgs.signal-desktop}/bin/signal-desktop --start-in-tray & disown";
      runAlways = true;
    };
    kitten-btop = {
      priority = 8;
      text = "${pkgs.kitty}/bin/kitten panel --detach --edge=background --focus-policy=exclusive ${output} ${pkgs.btop-cuda}/bin/btop & disown";
      runAlways = true;
    };
  };
}
