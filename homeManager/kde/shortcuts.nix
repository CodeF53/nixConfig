{ pkgs, ... }:

{
  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma.hotkeys.commands = {
    screenshot = {
      name = "take gradia screenshot";
      keys = [
        "Meta+Shift+S"
        "Print"
      ];
      command =
        (pkgs.writeScript "screenshot.sh" ''
          pkill gradia
          screenshot=$(mktemp --suffix=.png)
          ${pkgs.kdePackages.spectacle}/bin/spectacle --region --pointer --nonotify --background -o $screenshot
          if [ -s "$screenshot" ]; then ${pkgs.gradia}/bin/gradia $screenshot; fi
        '').outPath;
    };
    # toggleScreenPad = {
    #   key = "XF86Launch7";
    #   command = pkgs.writeShellScript "toggle-screenpad.sh" ''
    #     [ "$(cat /sys/class/leds/asus::screenpad/brightness)" -eq 0 ] && echo 255 > /sys/class/leds/asus::screenpad/brightness || echo 0 > /sys/class/leds/asus::screenpad/brightness
    #   '';
    # };
  };
}
