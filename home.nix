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
}
