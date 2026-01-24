{ pkgs, ... }:
{
  boot.kernelModules = [
    "i2c-nvidia-gpu"
    "i2c-dev"
  ];
  boot.kernelParams = [ "NVreg_EnableBacklightHandler=0" ];

  hardware.i2c.enable = true;
  environment.systemPackages = [ pkgs.ddcutil ];
  services.udev.packages = [ pkgs.ddcutil ];
  users.users.cassie.extraGroups = [
    "i2c"
    "video"
  ];
}
