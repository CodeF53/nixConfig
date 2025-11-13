{ inputs, pkgs, ... }:

{
  imports = [
    ./homeManager/cli
    ./homeManager/dev.nix
    ./homeManager/kde
    ./homeManager/mpv.nix
    ./homeManager/font.nix
    ./homeManager/zen.nix
    inputs.rootchat.homeModules.default
  ];
  programs.home-manager.enable = true;
  
  programs.rootchat = {
    enable = true;
    shaHash = "sha256-XJaref8NOWtr8QzK7nobRDp3k1pAKVdeU3LVe1GdjCI=";
  };

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
    stateVersion = "25.05";
  };

  # fix equibop's desktop entry not having a fucking icon
  xdg.desktopEntries.equibop = {
    name = "Equibop";
    exec = "${pkgs.equibop}/bin/equibop";
    icon = "${pkgs.equibop}/share/icons/hicolor/1024x1024/apps/equibop.png";
    comment = "Internet Messenger";
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };
  # note to self, ensure NoDevtoolsWarning is enabled if discord is logging you out constantly
  # https://github.com/Vencord/Vesktop/issues/375#issuecomment-1925395338
}
