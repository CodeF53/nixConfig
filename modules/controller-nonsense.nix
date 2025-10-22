{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    joycond
    joycond-cemuhook
  ];
  services.joycond.enable = true;
}
