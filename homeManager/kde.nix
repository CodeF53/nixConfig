{ ... }:

{
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    panels = [
      {
        location = "bottom";
        height = 30;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          {
            iconTasks.launchers = [
              "applications:zen-beta.desktop"
              "applications:equibop.desktop"
              "applications:org.kde.konsole.desktop"
              "applications:org.kde.dolphin.desktop"
              "applications:steam.desktop"
              "applications:systemsettings.desktop"
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
  };
}
