{ lib, pkgs, ... }:

let
  hyprwhspr-rs = (
    pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      pname = "hyprwhspr-rs";
      version = "v0.3.16";

      src = pkgs.fetchFromGitHub {
        owner = "better-slop";
        repo = finalAttrs.pname;
        tag = finalAttrs.version;
        hash = "sha256-ZiVooOo5VhvyM2s/fd5pW4nlCbI06QoAoHdXmfj/x/c=";
      };

      cargoHash = "sha256-n1aWPdIJmJy13lt8EyfgKuwVSVVJ9jtHq7RZ6FVsAl0=";

      nativeBuildInputs = with pkgs; [
        pkg-config
        makeWrapper
      ];

      buildInputs = with pkgs; [
        openssl_3
        alsa-lib
        onnxruntime
        systemd
        libxkbcommon
      ];

      # fix hardcoded binary/assets paths
      postPatch = ''
        # https://github.com/better-slop/hyprwhspr-rs/blob/b7e91a0f5727f164828ce708d9335ba8c7df24fb/src/config.rs#L753
        TARGET_FILE=$(grep -rIl "/usr/bin/whisper-cli" src)
        substituteInPlace "$TARGET_FILE" --replace-fail "/usr/bin/whisper-cli" "${lib.getExe pkgs.whisper-cpp}"

        # https://github.com/better-slop/hyprwhspr-rs/blob/b7e91a0f5727f164828ce708d9335ba8c7df24fb/src/config.rs#L778
        TARGET_FILE=$(grep -rIl "/usr/lib/hyprwhspr-rs/share/assets" src)
        substituteInPlace "$TARGET_FILE" --replace-fail "/usr/lib/hyprwhspr-rs/share/assets" "$out/share/assets"
      '';

      # default voice activation sounds
      postInstall = ''
        mkdir -p $out/share/assets
        cp -r assets/. $out/share/assets
      '';

      env = {
        ORT_STRATEGY = "system";
        ORT_LIB_LOCATION = "${pkgs.onnxruntime}/lib";
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
