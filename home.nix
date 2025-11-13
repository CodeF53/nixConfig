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

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
    stateVersion = "25.05";
  };

  programs.rootchat = {
    enable = true;
    shaHash = "sha256-hg26LvlGlEjmn4oDbVs1MZEzYUSpd9M5W0PfPsxQQHQ";
  };

  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      shown_boxes = "proc cpu mem net gpu0";
      update_ms = 1000;
      proc_sorting = "cpu direct";
      show_disks = false;
    };
  };

  # fix equibop's desktop entry not having a fucking icon
  xdg.desktopEntries.equibop = {
    name = "Equibop";
    exec = "${pkgs.equibop}/bin/equibop";
    icon = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Equicord/Equibop/refs/heads/main/static/icon.png";
      sha256 = "sha256:1clpay2rbasy56zizy9f5hnrc8bg0asb6sv9gc6aygjs9n0fmklj";
    };
    comment = "Internet Messenger";
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };
}
