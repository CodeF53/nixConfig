{ lib, pkgs, ... }:

let
  # https://github.com/NixOS/nixpkgs/pull/486473
  hyprwhspr-rs = (
    pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      pname = "hyprwhspr-rs";
      version = "0.3.17";
    
      src = pkgs.fetchFromGitHub {
        owner = "better-slop";
        repo = "hyprwhspr-rs";
        tag = "v${finalAttrs.version}";
        hash = "sha256-TzdicqIR59OVmGOI2AKo41mVt85sJyyf+tz7XI0v5CI=";
      };
    
      cargoHash = "sha256-VCV60rwNUUQ/KQ1VRLQ5IJu/P7DRpbRxsLc2dM1YQ4U=";
    
      nativeBuildInputs = [ pkgs.pkg-config ];
    
      buildInputs = with pkgs; [
        openssl
        alsa-lib
        onnxruntime
        systemd
        libxkbcommon
      ];
    
      # fix hardcoded binary/assets paths
      postPatch = ''
        substituteInPlace src/config.rs \
          --replace-fail "/usr/bin/whisper-cli" "${lib.getExe pkgs.whisper-cpp}" \
          --replace-fail "/usr/lib/hyprwhspr-rs/share/assets" "$out/share/assets"
      '';
    
      # default voice activation sounds
      postInstall = ''
        install -Dm644 assets/* --target-directory $out/share/assets
      '';
    
      # provide onnx runtime libraries to prevent default behavior of downloading them during the build step
      env = {
        ORT_STRATEGY = "system";
        ORT_LIB_LOCATION = "${lib.getLib pkgs.onnxruntime}/lib";
      };
    })
  );
in
{
  environment.systemPackages = [ hyprwhspr-rs ];
  users.users.cassie.extraGroups = [ "input" ];

  home-manager.users.cassie = { ... }: {
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
    xdg.configFile."hyprwhspr-rs/ggml-large-v3-turbo-q5_0.bin".source = (pkgs.fetchurl {
      url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q5_0.bin";
      sha256 = "sha256-OUIhcJzVrR9AxG5gMcphvOiJMebgiMGIKUxtWlX/p+I=";
    });
    xdg.configFile."hyprwhspr-rs/ggml-silero-v5.1.2.bin".source = (pkgs.fetchurl {
      url = "https://huggingface.co/ggml-org/silero-v5.1.2/resolve/main/ggml-silero-v5.1.2.bin";
      sha256 = "sha256-KZQNmNQrkfvQXOSJ8+z3xy8KQvAn5IdZGaKPtMBOos8=";
    });
  };
}
