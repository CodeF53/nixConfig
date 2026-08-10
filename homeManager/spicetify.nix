args@{ pkgs, ... }:
let
  spicePkgs = args.inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ args.inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
      volumePercentage
    ];
    theme = args.lib.mkForce spicePkgs.themes.catppuccin;
    colorScheme = args.lib.mkForce "mocha";
  };
}
