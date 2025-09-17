{ pkgs, ... }:

{
  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma = {
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

    # cassietop touchpad settings
    input.touchpads = [
      {
        name = "ASUE1406:00 04F3:3101 Touchpad";
        vendorId = "04f3";
        productId = "3101";
        disableWhileTyping = false;
      }
    ];

    # sessionRestore is stupid
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    # 100 is an insane default for this
    kwin.edgeBarrier = 50;
  };
}
