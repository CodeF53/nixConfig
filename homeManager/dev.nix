{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nil
  ];

  programs.git = {
    enable = true;
    userName = "Cassie";
    userEmail = "37855219+CodeF53@users.noreply.github.com";

    extraConfig = {
      core.editor = "micro";
      init.defaultBranch = "main";
      color.ui = true;
    };
  };

  programs.direnv.enable = true;
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    preferAbbrs = false;
    interactiveShellInit = ''
      set fish_greeting
      direnv hook fish | source
    '';
    functions = {
      nish.body = ''
        set -lx NIXPKGS_ALLOW_UNFREE 1
        set -l pkgs "github:NixOS/nixpkgs/nixos-unstable#"$argv
        command nix shell --impure (string join " " $pkgs)
      '';
    };
    shellAliases = {
      nano = "micro";
      sys-rebuild = "sudo nixos-rebuild switch --max-jobs auto --cores 16 --flake ~/nixConfig";
      sys-update = "nix flake update --flake ~/nixConfig && sys-rebuild";
    };
    plugins = with pkgs.fishPlugins; [
      { name = "autopair"; src = autopair.src; }
      { name = "bobthefish"; src = bobthefish.src; }
    ];
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "Fish";
    profiles.Fish = {
      command = "${pkgs.fish}/bin/fish";
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "toml" "vscode-dark-polished"];
    userSettings = {
      terminal.shell.program = "fish";
      theme = {
        mode = "dark";
        dark = "VSCode Dark Polished";
        light = "One Light"; # have to specify something otherwise it just doesnt work...
      };
      autosave.after_delay.milliseconds = 500;
      agent = {
        default_profile = "ask";
        default_model = {
          provider = "google";
          model = "gemini-2.5-flash";
        };
        version = "2";
      };
    };
  };
}
