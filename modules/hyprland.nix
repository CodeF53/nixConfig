{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.displayManager.ly.enable = true;
  environment.systemPackages = with pkgs; [
    lua-language-server

    hyprpaper
    hyprtoolkit
    playerctl
    jq
    hyprpolkitagent
    cliphist
    libqalculate
    quickshell
    kdePackages.qtdeclarative
    satty
    grim
    pavucontrol
    # microphone visualizer for hyprwhspr quickshell widget
    cava
    pulseaudio
  ];
  services.hypridle.enable = true;
  home-manager.users.cassie = { config, ... }: {
    xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink /home/cassie/nixConfig/hypr;
    xdg.configFile."quickshell".source =
      config.lib.file.mkOutOfStoreSymlink /home/cassie/nixConfig/quickshell;
  };
}
