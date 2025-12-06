{ pkgs, ... }:

# let
#   launchGamescopedSteam = pkgs.writeScript "gs.sh" ''
#     #!/usr/bin/env bash
#     set -xeuo pipefail

#     gamescopeArgs=(
#       --adaptive-sync
#       --hdr-enabled
#       --mangoapp
#       --rt
#       --steam
#     )
#     steamArgs=(-pipewire-dmabuf -tenfoot)
#     mangoConfig=(cpu_temp gpu_temp ram vram)
#     mangoVars=(
#       MANGOHUD=1
#       MANGOHUD_CONFIG="$(IFS=,; echo "''${mangoConfig[*]}")"
#     )

#     export "''${mangoVars[@]}"
#     exec gamescope "''${gamescopeArgs[@]}" -- steam "''${steamArgs[@]}"
#   '';
# in
{
  services.displayManager.sddm.enable = false;
  services.getty.autologinUser = "cassie";

  environment.systemPackages = with pkgs; [
    uwsm
    gamescope
    steam
  ];

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "literal fire";
        binPath = "${pkgs.hyprland}/bin/hyprland";
      };
      # gamescopeSteam = {
      #   prettyName = "Gamescoped Steam";
      #   comment = "like a steam deck";
      #   binPath = launchGamescopedSteam.outPath;
      # };
    };
  };

  programs.fish.shellInit = ''
    test -z "$DISPLAY" -a (tty) = "/dev/tty1" && command uwsm start -- select
  '';
}
