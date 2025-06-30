{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./homeManager/dev.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    equibop
  ];

  programs.zen-browser = {
    enable = true;
  };

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
  };
}
