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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      nano = "micro";
      sys-rebuild = "sudo nixos-rebuild switch --flake ~/nixConfig";
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
      # doesn't seem to work, would be really nice if it did...
      # context_servers = {
      #   nixos = {
      #     source = "custom";
      #     path = "nix";
      #     args = ["run" "github:utensils/mcp-nixos" "--"];
      #     env = {};
      #   };
      # };
    };
  };
}
