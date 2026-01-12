{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
      memtest86.enable = true;
    };
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
  hardware.bluetooth.enable = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables.NIXOS_OZONE_WL = 1;

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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    (
      (pkgs.discord.override (old: {
        withOpenASAR = true;
        withEquicord = true;
        withTTS = false;
      })).overrideAttrs
      (old: {
        postInstall = old.postInstall + ''
          echo 'require ("/home/cassie/proj/Equicord/dist/desktop/patcher.js")' > $out/opt/Discord/resources/app.asar/index.js
        '';
      })
    ) # consider switching to declaritavely defining plugins https://github.com/KaylorBen/nixcord
    equibop # for developing plugins
    pnpm
    git
    footswitch # https://amazon.com/dp/B08MC4PFHY/
    pwvucontrol
    croc
    qbittorrent
    signal-desktop
    opencode
    livecaptions
    wl-clipboard
    syncplay
    rar
    nixfmt-rfc-style
  ];

  # https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nix.settings = {
    trusted-users = [ "cassie" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  # ssh!
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.cassie.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDUj/KeS2gfoq1D8X4jQYM+rCgx5+3ls7vTpb0/HVnI"
  ];
  networking.firewall.enable = false;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "escape";
        escape = "capslock";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
