extras@{ pkgs, ... }:

{
  imports = [
    extras.inputs.zen-browser.homeModules.beta
    extras.inputs.plasma-manager.homeModules.plasma-manager
    ./homeManager/cli
    ./homeManager/dev.nix
    ./homeManager/kde
    ./homeManager/mpv.nix
    ./homeManager/font.nix
    ./homeManager/flameshot.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    qbittorrent
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
}
