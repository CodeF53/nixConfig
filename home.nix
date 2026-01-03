{ inputs, pkgs, ... }:

{
  imports = [
    ./homeManager/cli
    ./homeManager/dev.nix
    ./homeManager/mpv.nix
    ./homeManager/zen.nix
    ./homeManager/notifications.nix
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
    shaHash = "sha256-F4DyFbeSFNAqchMldbPllGWt0kCsg+xBnGrMKA8N8MM=";
  };

  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      shown_boxes = "proc cpu mem net";
      update_ms = 1000;
      proc_sorting = "cpu direct";
      show_disks = false;
    };
  };
}
