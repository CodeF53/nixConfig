{ pkgs, ... }:

{
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprlauncher
    hyprpaper
    hyprtoolkit
    hyprshot
    playerctl
    jq
    hyprpolkitagent
  ];
  home-manager.users.cassie = { config, ... }: {
    xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink /home/cassie/nixConfig/hypr;
  };
}
