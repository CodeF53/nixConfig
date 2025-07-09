{ ... }:

{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.onActivation = true;
    packages = [
      "org.vinegarhq.Sober"
    ];
  };
}
