{ ... }:

{
  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma.panels = [
    {
      screen = 0;
      location = "bottom";
      height = 30;
      widgets = [
        {
          kickoff = {
            sortAlphabetically = true;
            icon = "/home/cassie/nixConfig/files/trans-nix.svg";
          };
        }
        {
          iconTasks.launchers = [
            "applications:zen-beta.desktop"
            "applications:discord.desktop"
            "applications:kitty.desktop"
            "applications:org.kde.dolphin.desktop"
            "applications:steam.desktop"
          ];
        }
        "org.kde.plasma.marginsseparator"
        {
          systemTray.items = {
            shown = [
              "org.kde.plasma.volume"
              "org.kde.plasma.brightness"
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.networkmanagement"
              "org.kde.plasma.battery"
              "org.kde.plasma.powerdevil"
            ];
            hidden = [ "org.kde.plasma.clipboard" ];
          };
        }
        {
          digitalClock = {
            calendar.firstDayOfWeek = "monday";
            time.format = "12h";
          };
        }
      ];
    }
  ];
}
