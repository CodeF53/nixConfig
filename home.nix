extras@{ pkgs, ... }:

{
  imports = [
    extras.inputs.zen-browser.homeModules.beta
    extras.inputs.plasma-manager.homeManagerModules.plasma-manager
    ./homeManager/dev.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
  ];

  # fix equibop's desktop entry not having a fucking icon
  xdg.desktopEntries.equibop = {
    name = "Equibop";
    exec = "${pkgs.equibop}/bin/equibop";
    icon = "${pkgs.equibop}/share/icons/hicolor/1024x1024/apps/equibop.png";
    comment = "Internet Messenger";
    categories = [ "Network" "InstantMessaging" "Chat" ];
  };
  # note to self, ensure NoDevtoolsWarning is enabled if discord is logging you out constantly
  # https://github.com/Vencord/Vesktop/issues/375#issuecomment-1925395338

  programs.zen-browser = {
    enable = true;
  };

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    panels = [
      {
        location = "bottom";
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
