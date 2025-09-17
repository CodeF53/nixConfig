{ pkgs, ... }:

{
  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma.hotkeys.commands = {
    screenshot = {
      name = "launch flameshot";
      keys = [
        "Meta+Shift+S"
        "Print"
      ];
      command = "env QT_QPA_PLATFORM=xcb ${pkgs.flameshot}/bin/flameshot gui";
    };
    # toggleScreenPad = {
    #   key = "XF86Launch7";
    #   command = pkgs.writeShellScript "toggle-screenpad.sh" ''
    #     [ "$(cat /sys/class/leds/asus::screenpad/brightness)" -eq 0 ] && echo 255 > /sys/class/leds/asus::screenpad/brightness || echo 0 > /sys/class/leds/asus::screenpad/brightness
    #   '';
    # };
  };
}
