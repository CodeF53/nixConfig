{ inputs, pkgs, ... }:

{
  imports = [
    ./homeManager/cli
    ./homeManager/dev.nix
    ./homeManager/mpv.nix
    ./homeManager/zen.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
    stateVersion = "25.05";
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
