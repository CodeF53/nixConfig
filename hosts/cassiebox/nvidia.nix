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
    package =
      (config.boot.kernelPackages.extend (
        final: prev:
        let
          generic = args: final.callPackage (import "${inputs.nixpkgs}/pkgs/os-specific/linux/nvidia-x11/generic.nix" args) { };
        in
        {
          nvidiaPackages.latest =
            (generic {
              version = "595.91.07";
              sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
              sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
              openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
              settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
              persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
              patches = [];
              patchesOpen = [ ./nvidia-bsb-dsc-fix.patch ];
            });
        }
      )).nvidiaPackages.latest;
    open = true;
    nvidiaSettings = true;
  };
}
