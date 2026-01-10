{
  services.pipewire.extraConfig.pipewire."99-combine-sink"."context.modules" = [
    {
      name = "libpipewire-module-combine-stream";
      args = {
        "combine.mode" = "sink";
        "node.name" = "combined_output";
        "node.description" = "mochie co-op gooning audio";
        "combine.props" = {
          "audio.position" = [ "FL" "FR" ];
          "priority.driver" = 1500;
          "priority.session" = 1500;
        };
        "stream.rules" = [
          {
            # array works as logical OR
            matches = [
              { "node.name" = "alsa_output.usb-SteelSeries_Arctis_Nova_Pro"; }
              # rear audio output jack (dumbass dog NEEDS her "ATH-M50x"s EVERYWHERE)
              { "node.nick" = "ALC897 Analog"; }
            ];
            actions = {
              create-stream = {
                "audio.position" = [ "FL" "FR" ];
                "combine.audio.position" = [ "FL" "FR" ];
              };
            };
          }
        ];
      };
    }
  ];

  services.pipewire.wireplumber.extraConfig = {
    "99-disable-useless-devices"."monitor.alsa.rules" = [
      {
        # disable audio devices I never use
        matches = [
          { "device.description" = "HDA NVidia"; } # GPU HDMI
          { "device.description" = "NexiGo N60 FHD Webcam"; }
          { "device.description" = "~Radeon High Definition Audio.*"; } # iGPU/AMD HDMI
          # { "device.description" = "Family 17h/19h/1ah HD Audio Controller"; } # motherboard (3.5mm jacks)
        ];
        actions.update-props."device.disabled" = true;
      }
      {
        matches = [
          {
            # never use microphone as an output device
            "node.description" = "Yeti Nano Analog Stereo";
            "media.class" = "Audio/Sink";
          }
        ];
        actions.update-props."node.disabled" = true;
      }
    ];
  };
}
