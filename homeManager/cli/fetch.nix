{ ... }:

{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      auto_detect_light_dark = true;
      light_dark = "dark";
      lightness = 0.65;
      color_align.mode = "horizontal";
      backend = "fastfetch";
      pride_month_disable = false;
    };
  };
  programs.fastfetch = {
    enable = true;
    settings.modules = [
      "title"
      "os"
      "host"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "de"
      "wm"
      "font"
      "terminalfont"
      "terminal"
      "cpu"
      "gpu"
      "memory"
      "disk"
    ];
  };
}
