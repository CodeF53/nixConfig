{ pkgs, lib, ... }:

lib.mkMerge [
  { # elgato wave 3 fixes
    # Disable USB autosuspend
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0070", ATTR{power/control}="on"
    '';
  
    services.pipewire.wireplumber.extraConfig."50-elgato-wave3"."monitor.alsa.rules" = [
      {
        # Default to pro-audio profile
        matches = [{ "device.name" = "~alsa_card.usb-Elgato_Systems_Elgato_Wave_3_*"; }];
        actions.update-props."device.profile" = "pro-audio";
      }
      {
        # Disable idle sleep timeout
        matches = [{ "node.name" = "~alsa_input.usb-Elgato_Systems_Elgato_Wave_3_*"; }];
        actions.update-props."session.suspend-timeout-seconds" = 0;
      }
    ];
  }
  {
    services.pipewire.wireplumber.extraConfig."99-disable-useless-devices"."monitor.alsa.rules" = [
      {
        # disable audio devices I never use
        matches = [
          { "device.description" = "HDA NVidia"; } # GPU HDMI
          { "device.description" = "NexiGo N60 FHD Webcam"; }
          { "device.description" = "~Radeon High Definition Audio.*"; } # iGPU/AMD HDMI
          { "device.description" = "Family 17h/19h/1ah HD Audio Controller"; } # motherboard (3.5mm jacks)
        ];
        actions.update-props."device.disabled" = true;
      }
      {
        # microphone is not an output..
        matches = [{
          "node.name" = "~alsa_output.usb-Elgato_Systems_Elgato_Wave_3_*";
          "media.class" = "Audio/Sink";
        }];
        actions.update-props."node.disabled" = true;
      }
    ];
  }
]
