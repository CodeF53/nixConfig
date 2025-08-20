{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.file."/.local/share/fonts/Mochie_Iosevka/MochieIosevka-Regular.ttf".source =
    ../files/MochieIosevka-Regular.ttf;

  home.file."/.local/share/fonts/Nunito/Nunito-VariableFont_wght.ttf".source =
    ../files/Nunito-VariableFont_wght.ttf;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    twitter-color-emoji
  ];

  programs.plasma.fonts = {
    general = { family = "Nunito"; pointSize = 10; };
    fixedWidth = { family = "MochieIosevka"; pointSize = 10; };
    small = { family = "Nunito"; pointSize = 8; };
    toolbar = { family = "Nunito"; pointSize = 10; };
    menu = { family = "Nunito"; pointSize = 10; };
    windowTitle = { family = "Nunito"; pointSize = 10; };
  };
}
