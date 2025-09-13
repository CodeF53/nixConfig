{
  config,
  ...
}:
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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = true;
    nvidiaSettings = true;
  };
}
