{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nil
    kitty
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
      sys-rebuild = "git -C ~/nixConfig add . && sudo nixos-rebuild switch --max-jobs auto --cores 16 --flake ~/nixConfig";
      sys-update = "nix flake update --flake ~/nixConfig && sys-rebuild";
    };
    plugins = with pkgs.fishPlugins; [
      { name = "autopair"; src = autopair.src; }
      { name = "bobthefish"; src = bobthefish.src; }
    ];
  };

  programs.kitty = {
    enable = true;
    font = { name = "Mochie Iosevka"; size = 16; };
    settings = {
      confirm_os_window_close = 0; # no close warning
      wayland_titlebar_color = "background";
      enable_audio_bell = false;
      cursor_shape = "beam";
      tab_bar_edge = "top";
      shell = "fish";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      # nerd font for nerd font symbols
      symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6AA,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF,U+F0001-U+F1AF0 Symbols Nerd Font Mono";
    };
    keybindings = { "ctrl+shift+w" = "close_tab"; };
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
      };
      title_bar = {
        show_onboarding_banner = false;
        show_user_picture = false;
        show_sign_in = false;
      };
    };
  };
}
