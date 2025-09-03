{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/DarkestHour/contents/images/2560x1600.jpg";
    };

    # Disable the stupid thing that happens when you put your mouse in the upper left
    configFile = {
      kwinrc = {
        Effect-Overview.activationBorder = 0;
        Effect-overview.BorderActivate = 9;
      };
    };
    
    # the taskbar in question
    panels = [
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
              "applications:equibop.desktop"
              "applications:kitty.desktop"
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
    
    # cassietop touchpad settings
    input.touchpads = [{
      name = "ASUE1406:00 04F3:3101 Touchpad";
      vendorId = "04f3";
      productId = "3101";
      disableWhileTyping = false;
    }];
    
    # sessionRestore is stupid
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
  };
}
