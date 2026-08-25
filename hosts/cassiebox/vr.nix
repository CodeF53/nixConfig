args@{ pkgs, ... }:

args.lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [ wayvr ];
  }
  {
    # https://wiki.vronlinux.org/docs/hardware/bigscreen-beyond/#udev-rules
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", GROUP="users"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", GROUP="users"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="1001", MODE="0660", GROUP="users"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", GROUP="users"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0282", MODE="0660", GROUP="users"
    '';
  }
  
  {
    nixpkgs.overlays = [ (final: prev: { onnxruntime = prev.onnxruntime.override { cudaSupport = false; }; }) ];
    
    services.monado = {
      enable = true;
      highPriority = true;
    };
    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "true";
      LH_OVERRIDE_IPD_MM = "61";
      VP2_RESOLUTION = "2";
      XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";
      XRT_COMPOSITOR_FORCE_NVIDIA = "0";
      # preformance env vars from lvra discord
      XRT_COMPOSITOR_USE_PRESENT_WAIT = "1";
      U_PACING_COMP_TIME_FRACTION_PERCENT = "90";
      U_PACING_APP_USE_MIN_FRAME_PERIOD = "1";
      U_PACING_APP_IMMEDIATE_WAIT_FRAME_RETURN_BELOW_REFRESH = "1";
    };
  }

  {
    # https://wiki.vronlinux.org/docs/distros/nixos/#runtimes
    home-manager.users.cassie.xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
  }

  {
    # https://wiki.vronlinux.org/docs/distros/nixos/#steam-games-and-openvr-apps
    programs.steam.package = pkgs.steam.override {
      extraProfile = ''
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1 # this doesnt work, set per game
        unset TZ
      '';
    };
    environment.systemPackages = with pkgs; [
      xrizer
      openxr-loader
    ];
    home-manager.users.cassie = { config, ... }: 
      let steam = "${config.xdg.dataHome}/Steam"; in 
      {
        xdg.configFile."openvr/openvrpaths.vrpath".text = builtins.toJSON {
          version = 1;
          jsonid = "vrpathreg";
          external_drivers = null;
          config = [ "${steam}/config" ];
          log = [ "${steam}/logs" ];
          runtime = [ "${pkgs.xrizer}/lib/xrizer" ];
        };
      };
  }
]
