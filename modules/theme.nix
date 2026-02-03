{ pkgs, ... }:

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
}
