{ pkgs, ... }:

{
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprtoolkit
    hyprshot
    playerctl
    jq
    hyprpolkitagent
    cliphist
    libqalculate
    quickshell
    kdePackages.qtdeclarative
    # microphone visualizer for hyprwhspr quickshell widget
    cava
    pulseaudio
  ];
  home-manager.users.cassie = { config, ... }: {
    xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink /home/cassie/nixConfig/hypr;
    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink /home/cassie/nixConfig/quickshell;
  };
}
