{ pkgs, ... }:

{
  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma.hotkeys.commands = {
    screenshot = {
      name = "launch spectacle";
      keys = [
        "Meta+Shift+S"
        "Print"
      ];
      command = "${pkgs.writeShellScript "screenshot.sh" ''
        ${pkgs.kdePackages.spectacle}/bin/spectacle --region --pointer --nonotify --background -o /dev/stdout | ${pkgs.gradia}/bin/gradia
      ''}";
    };
    # toggleScreenPad = {
    #   key = "XF86Launch7";
    #   command = pkgs.writeShellScript "toggle-screenpad.sh" ''
    #     [ "$(cat /sys/class/leds/asus::screenpad/brightness)" -eq 0 ] && echo 255 > /sys/class/leds/asus::screenpad/brightness || echo 0 > /sys/class/leds/asus::screenpad/brightness
    #   '';
    # };
  };
}
