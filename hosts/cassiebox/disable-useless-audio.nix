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
      matches = [
        { # never use microphone as an output device
          "node.description" = "Yeti Nano Analog Stereo";
          "media.class" = "Audio/Sink";
        }
      ];
      actions.update-props."node.disabled" = true;
    }
  ];
}
