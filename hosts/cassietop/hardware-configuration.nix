extras@{ config, pkgs, ... }:

let
  asusWmiScreenpad = config.boot.kernelPackages.callPackage ./asus-wmi-screenpad.nix { };
in
{
  hardware.enableRedistributableFirmware = extras.lib.mkDefault true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "uas"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "asus_wmi_screenpad"
  ];
  boot.extraModulePackages = [ asusWmiScreenpad ];
  # enable changing screenpad brightness without giving permission everytime after reboot
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="asus::screenpad", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/leds/%k/brightness"
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b868d8c3-e35a-4ee9-b7fa-b01328420948";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4C66-0AE6";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/de31999e-59db-423b-9ee9-e969ab345e89"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = extras.lib.mkDefault true;
  # networking.interfaces.enp0s20f0u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = extras.lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = extras.lib.mkDefault extras.config.hardware.enableRedistributableFirmware;

  # gpu :husk:
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    open = true;
    nvidiaSettings = true;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
        offloadCmdMainProgram = "dgpu";
      };
    };
  };
  # trying to fix sleep leading to gpu memory corruption
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  # the duality of laptop
  powerManagement.cpuFreqGovernor = "performance";
  services.throttled.enable = true;
  services.power-profiles-daemon.enable = false;
  environment.systemPackages = [ pkgs.auto-cpufreq ];
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      energy_performance_preference = "performance";
      energy_perf_bias = 0;
      turbo = "always";
    };
    battery = {
      governor = "powersave"; # performance powersave
      energy_performance_preference = "power"; # default performance balance_performance balance_power power
      energy_perf_bias = 15; # 0-15 where 15 saves most
      turbo = "never";
    };
  };
}
