extras@{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "Mon,Wed,Fri,Sun *-*-* 00:00:00";
    options = "--delete-old";
  };

  networking = {
    hostName = "cassietop";
    # wireless.enable = true;
    networkmanager.enable = true;
  };

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager = {
    sddm.enable = true;
    autoLogin.enable = true;
    autoLogin.user = "cassie";
    defaultSession = "plasma";
  };
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.cassie = {
    isNormalUser = true;
    description = "cassie";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # $ nix search NAME
  environment.systemPackages = with pkgs; [
    git
    micro
  ];
  # kinda upset this cant be in home.nix...
  programs.steam.enable = true;

  # ssh!
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.cassie.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDUj/KeS2gfoq1D8X4jQYM+rCgx5+3ls7vTpb0/HVnI" ];
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
