args@{ pkgs, ... }:

{
  hardware.usb-modeswitch.enable = true;
  boot.extraModulePackages = [ args.config.boot.kernelPackages.rtl8852au ];
  boot.initrd.kernelModules = [ "8852au" ];
}
