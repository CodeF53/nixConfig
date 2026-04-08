{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.hyprwhspr-rs ];
  services.hyprwhspr-rs.enable = true;
  users.users.cassie.extraGroups = [ "input" ];

  home-manager.users.cassie = {
    xdg.configFile."hyprwhspr-rs/config.jsonc".text = builtins.toJSON {
      shortcuts.hold = "SUPER+R";
      word_overrides = {
        "Blue Sky" = "bluesky";
        "Hyperland" = "hyprland";
        "hyperland" = "hyprland";
      };
      audio_feedback = true;
      transcription = {
        provider = "whisper_cpp";
        whisper_cpp = {
          model = "large-v3-turbo-q5_0";
          models_dirs = [ "~/.config/hyprwhspr-rs/" ];
          vad.enabled = true;
        };
      };
    };
    xdg.configFile."hyprwhspr-rs/ggml-large-v3-turbo-q5_0.bin".source = (
      pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q5_0.bin";
        sha256 = "sha256-OUIhcJzVrR9AxG5gMcphvOiJMebgiMGIKUxtWlX/p+I=";
      }
    );
    xdg.configFile."hyprwhspr-rs/ggml-silero-v5.1.2.bin".source = (
      pkgs.fetchurl {
        url = "https://huggingface.co/ggml-org/silero-v5.1.2/resolve/main/ggml-silero-v5.1.2.bin";
        sha256 = "sha256-KZQNmNQrkfvQXOSJ8+z3xy8KQvAn5IdZGaKPtMBOos8=";
      }
    );
  };
}
