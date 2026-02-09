{ config, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  nixpkgs.config = {
    cudaSupport = true;
    cudaCapabilities = [ "8.9" ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = true;
    nvidiaSettings = true;
  };
}
