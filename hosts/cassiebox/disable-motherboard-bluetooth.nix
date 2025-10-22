{ ... }:

{
  # Disable the built-in Realtek Bluetooth adapter (ID 0bda:0852), I use a TP-Link UB500
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="0852", ATTR{authorized}="0"
  '';
}
