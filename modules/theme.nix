{
  lib,
  pkgs,
  config,
  ...
}:

let
  nunito = pkgs.stdenv.mkDerivation {
    pname = "nunito";
    version = "1.0";
    src = pkgs.fetchzip {
      url = "https://github.com/googlefonts/nunito/archive/main.zip";
      hash = "sha256-m276Gnkwpd+MjHo4mPU1RBcTs34puao7Wi+OOEuTuI0=";
    };
    installPhase = "install -m444 -Dt $out/share/fonts/truetype fonts/variable/*.ttf";
  };
  mochie-iosevka = pkgs.stdenv.mkDerivation {
    pname = "mochie-iosevka";
    version = "1.0";
    src = ../files/MochieIosevka-Regular.ttf;
    dontUnpack = true;
    installPhase = "install -m444 -Dt $out/share/fonts/truetype $src";
  };
in
{
  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.image = ../files/background.jpg;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.fonts = {
    serif = {
      name = "Nunito";
      package = nunito;
    };
    sansSerif = {
      name = "Nunito";
      package = nunito;
    };
    monospace = {
      name = "Mochie Iosevka";
      package = mochie-iosevka;
    };
    emoji = {
      name = "Twitter Color Emoji";
      package = pkgs.twitter-color-emoji;
    };

    sizes.terminal = 10;
  };

  fonts.packages = with pkgs; [
    nunito
    mochie-iosevka
    twitter-color-emoji
    nerd-fonts.symbols-only
    rounded-mgenplus
  ];
  fonts.fontconfig.defaultFonts =
    let
      extraFonts = [
        "Twitter Color Emoji"
        "Symbols Nerd Font"
        "Rounded Mgen+ 1c"
      ];
    in
    {
      serif = [ "Nunito" ] ++ extraFonts;
      sansSerif = [ "Nunito" ] ++ extraFonts;
      monospace = [ "Mochie Iosevka" ] ++ extraFonts;
    };

  stylix.cursor = {
    name = "Posy_Cursor";
    package = pkgs.posy-cursors;
    size = 32;
  };

  home-manager.users.cassie = {
    # global dark mode fixes
    dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-dark";
    systemd.user.sessionVariables = config.home-manager.users.cassie.home.sessionVariables;
    home.sessionVariables.GTK_USE_PORTAL = "1";
    gtk = {
      enable = true;
      theme = {
        package = lib.mkForce pkgs.magnetic-catppuccin-gtk;
        name = lib.mkForce "Catppuccin-GTK-Dark";
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
      style.name = "kvantum";
    };

    catppuccin = {
      enable = true;
      cache.enable = true;
    };

    # fix stylix and catppuccin infighting
    stylix.targets.btop.colors.enable = false;
    stylix.targets.yazi.colors.enable = false;
    stylix.targets.zed.colors.enable = false;
    stylix.targets.gtk.colors.enable = false;
    stylix.targets.qt.enable = false;
  };
}
