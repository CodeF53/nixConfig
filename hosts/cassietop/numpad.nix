{ inputs, ... }:

{
  imports = [
    inputs.asus-numberpad-driver.nixosModules.default
  ];

  services.asus-numberpad-driver = {
    enable = true;
    layout = "ux581l";
    # hyprland just be lime that...
    waylandDisplay = "wayland-1";
  };
}
