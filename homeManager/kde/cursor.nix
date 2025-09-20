{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    name = "Posy_Cursor";
    package = pkgs.posy-cursors;
    size = 32;
  };
}
