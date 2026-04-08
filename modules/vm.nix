{ pkgs, ... }:

{
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    virtio-win
  ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.cassie.extraGroups = [ "libvirtd" "kvm" ];
}
