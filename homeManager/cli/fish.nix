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
        argparse -N1 'm/master' -- $argv; or return 1

        if set -q _flag_master
            set -f pkgs "github:NixOS/nixpkgs/master#"$argv
        else
            set -f pkgs "nixpkgs#"$argv
        end

        set -fx NIXPKGS_ALLOW_UNFREE 1
        command nix shell --impure $pkgs
      '';
    };
    shellAliases = {
      nano = "micro";
      cat = "bat";
      ls = "eza -1 -l -a -F --color=always --icons --no-permissions --no-user --no-time --no-filesize";
      sys-rebuild = "nh os switch ~/nixConfig --hostname ${extras.host}";
      sys-update = "nh os switch --update ~/nixConfig --hostname ${extras.host}";
      sys-update-shutdown = "nh os boot --update ~/nixConfig --hostname ${extras.host} && sudo shutdown now";
      sys-clean = "nh clean all";
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
