{ config, pkgs, ... }:
let
  auto-sub =
    let
      file = builtins.toFile "auto-sub.lua" ''
        mp.add_hook('on_load', 10, function ()
          mp.set_property('sub-file-paths', 'Subs/' .. mp.get_property('filename/no-ext'))
        end)
      '';
    in
    pkgs.mpvScripts.buildLua {
      pname = "auto-sub";
      version = "1.0.0";
      src = file;
      unpackPhase = ":";
      scriptPath = file;
    };
  seek-end =
    let
      file = builtins.toFile "seek-end.lua" ''
        function seek_end()
          mp.commandv("seek", mp.get_property_number("duration") - 5, "absolute")
        end
        mp.add_key_binding(nil, "seek_end", seek_end)
      '';
    in
    pkgs.mpvScripts.buildLua {
      pname = "seek-end";
      version = "1.0.0";
      src = file;
      unpackPhase = ":";
      scriptPath = file;
    };
  mpv-thumbnail-script-server = pkgs.mpvScripts.buildLua {
    pname = "mpv-thumbnail-script-server";
    version = "git";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Zren/mpv-osc-tethys/master/mpv_thumbnail_script_server.lua";
      sha256 = "1xV/DmuOJCCWkQAPd8RIcL3M6tohUZlqcaTZYYAaPrk=";
    };
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/share/mpv/scripts
      cp $src $out/share/mpv/scripts/mpv_thumbnail_script_server.lua
    '';
    scriptPath = "share/mpv/scripts/mpv_thumbnail_script_server.lua";
  };
in
{
  programs.mpv = {
    enable = true;
    config = {
      input-default-bindings = false;
      input-builtin-bindings = false;
      sub-outline-color = "0.0/0.3";
      sub-border-style = "opaque-box";
      sub-outline-size = -2;
      sub-filter-regex-append = "opensubtitles\\.org";
      sub-auto = "all";
      hidpi-window-scale = false;
      hwdec = "auto";
      profile = "high-quality";
      # vo = "gpu-next";
      vulkan-swap-mode = "auto";
      gpu-context = "wayland";
      # youtube!
      ytdl-format = "bestvideo+bestaudio/best";
      slang = "en";
      ytdl-raw-options = "ignore-config=,sub-lang=en,write-sub=,write-auto-sub=,embed-chapters=";
      script-opts = "ytdl_hook-ytdl_path=/run/current-system/sw/bin/yt-dlp";
    };
    bindings = {
      "]" = "add speed 0.5";
      "[" = "add speed -0.5";
      SPACE = "cycle pause";
      RIGHT = "seek 5 exact";
      LEFT = "seek -5 exact";
      v = "cycle sub";
      V = "cycle sub down";
      b = "cycle audio";
      B = "cycle audio down";
      f = "cycle fullscreen";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      j = "add chapter -1";
      l = "add chapter 1";
      y = "script-binding seek_end";
      "`" = "script-binding console/enable";
    };
    scripts =
      with pkgs.mpvScripts;
      [
        # mpv-osc-tethys
        # mpv-discord
      ]
      ++ [
        seek-end
        auto-sub
        mpv-thumbnail-script-server
      ];
  };
}
