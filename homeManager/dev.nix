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

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "vscode-dark-polished"
    ];
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
