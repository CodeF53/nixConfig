{ config, inputs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    package = let
        base = config.boot.kernelPackages.nvidiaPackages.latest;
      in base.overrideAttrs (prev: {
        passthru = prev.passthru // {
          open = base.open.overrideAttrs (prevOpen: {
            patches = (prevOpen.patches or [ ]) ++ [ ./nvidia-bsb-dsc-fix.patch ];
          });
        };
      });
    # package =
    #   (config.boot.kernelPackages.extend (
    #     final: prev:
    #     let
    #       generic = args: final.callPackage (import "${inputs.nixpkgs}/pkgs/os-specific/linux/nvidia-x11/generic.nix" args) { };
    #     in
    #     {
    #       nvidiaPackages.latest =
    #         (generic {
    #           version = "595.104.02";
    #           sha256_64bit = "sha256-5CHCAuTHn1jDx/MWG75xRU67PYiTb4ggWg4yfNBMWco=";
    #           sha256_aarch64 = "sha256-PafStmwNMufeDp3VtpTGGCoW+53Gor/mieO1m1pI7gI=";
    #           openSha256 = "sha256-FWk5ra2yjz8VAxAA8GXrSoeBj/XC1BKvsKsBKR09joE=";
    #           settingsSha256 = "sha256-4Kxro6tvI5aX4nu2RspgyBsW+Jq3/VYjSAS5UGdzTCU=";
    #           persistencedSha256 = "sha256-JsMLPqJuZwAtHngsQODMsmgO7F2tVkQ2arc7fYa2bwo=";
    #           patches = [];
    #           patchesOpen = [ ./nvidia-bsb-dsc-fix.patch ];
    #         });
    #     }
    #   )).nvidiaPackages.latest;
    open = true;
    nvidiaSettings = true;
  };
}
