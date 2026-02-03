{ lib, pkgs, ... }:

let
  # https://github.com/NixOS/nixpkgs/pull/486473
  hyprwhspr-rs = (
    pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      pname = "hyprwhspr-rs";
      version = "0.3.16";
    
      src = pkgs.fetchFromGitHub {
        owner = "better-slop";
        repo = "hyprwhspr-rs";
        tag = "v${finalAttrs.version}";
        hash = "sha256-ZiVooOo5VhvyM2s/fd5pW4nlCbI06QoAoHdXmfj/x/c=";
      };
    
      cargoHash = "sha256-n1aWPdIJmJy13lt8EyfgKuwVSVVJ9jtHq7RZ6FVsAl0=";
    
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
        provider = "parakeet";
        parakeet.model_dir = "~/.config/hyprwhspr-rs/parakeet";
      };
    };
    xdg.configFile."hyprwhspr-rs/parakeet".source = (pkgs.fetchgit {
      url = "https://huggingface.co/istupakov/parakeet-tdt-0.6b-v3-onnx";
      rev = "abd2878d52a678ce380088ef9d9b1d9664404565";
      sha256 = "sha256-eaxzbE7aEYku66iyRUez30OHYTExWI0dbybfo32pEug=";
      fetchLFS = true;
    });
  };
}
