extras@{ pkgs, ... }:

{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    preferAbbrs = false;
    interactiveShellInit = ''
      set fish_greeting
      if string match -q -e "kitty" $TERM; command hyfetch; end

      direnv hook fish | source

      zoxide init fish --cmd cd | source
      fzf --fish | source

      # bobthefish config
      set -g theme_nerd_fonts yes
      set -g theme_title_display_process yes
      set -g theme_display_date no
    '';
    functions = {
      nish.body = ''
        set -lx NIXPKGS_ALLOW_UNFREE 1
        set -l pkgs "github:NixOS/nixpkgs/nixos-unstable#"$argv
        command nix shell --impure $pkgs
      '';
    };
    shellAliases = {
      nano = "micro";
      cat = "bat";
      ls = "eza -1 -l -a -F --color=always --icons --no-permissions --no-user --no-time --no-filesize";
      sys-rebuild = "git -C ~/nixConfig add . && sudo nixos-rebuild switch --max-jobs auto --cores 16 --flake ~/nixConfig#${extras.host}";
      sys-update = "nix flake update --flake ~/nixConfig && sys-rebuild";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "bobthefish";
        src = bobthefish.src;
      }
    ];
  };
}
