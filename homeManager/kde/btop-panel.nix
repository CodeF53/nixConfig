extras@{ pkgs, ... }:

let
  outputMap = {
    cassiebox = "HDMI-A-2";
    cassietop = "DP-3";
  };
  output = "--output-name=${outputMap.${extras.host}}";
in
{
  programs.plasma.startup.startupScript.kitten-btop = {
    text = ''
      ${pkgs.kitty}/bin/kitten panel --detach --edge=background --focus-policy=exclusive ${output} ${pkgs.btop}/bin/btop
    '';
    runAlways = true;
  };
}
