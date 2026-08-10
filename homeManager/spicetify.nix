args@{ pkgs, ... }:
let
  spicePkgs = args.inputs.spicetify-nix.legacyPackages.${args.pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ args.inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      trashbin
      keyboardShortcut
      goToSong
      listPlaylistsWithSong
      history
      savePlaylists
      playNext
      volumePercentage
      playingSource
      beautifulLyrics
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
    theme = spicePkgs.themes.catppucin;
    colorScheme = "Spotify";
  };
}
