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

  # todo: make more advaced with https://gist.github.com/jtrv/47542c8be6345951802eebcf9dc7da31
  services.easyeffects.enable = true;

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
