{
  pkgs,
  lib,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    vscode
    bun
    nodejs_latest
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Cassie";
      user.email = "37855219+CodeF53@users.noreply.github.com";
      core.editor = "micro";
      init.defaultBranch = "main";
      color.ui = true;
      submodule.recurse = true;
    };
  };

  programs.direnv.enable = true;

  programs.zed-editor = {
    enable = true;
    extraPackages = [ pkgs.nixd ];
    extensions = [
      "nix"
      "toml"
      "vscode-dark-polished"
    ];
    userSettings = {
      languages.Nix.language_servers = [
        "nixd"
        "!nil"
      ];
      lsp.nixd.settings =
        let
          myFlake = "(builtins.getFlake \"/home/cassie/nixConfig\")";
        in
        {
          nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { config.allowUnfree = true; }";
          options = {
            nixos.expr = "${myFlake}.nixosConfigurations.cassiebox.options";
            # home-manager.expr = "${myFlake}.nixosConfigurations.cassiebox.options.home-manager.users.type.getSubOptions []";
            home-manager.expr = lib.replaceStrings [ "\n" ] [ " " ] ''
              (${myFlake}.inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = ${myFlake}.inputs.nixpkgs.legacyPackages.x86_64-linux;
                modules = [
                  ${myFlake}.inputs.zen-browser.homeModules.default
                  ${myFlake}.inputs.plasma-manager.homeModules.plasma-manager {
                    home = {
                      stateVersion = "${config.home.stateVersion}";
                      username = "${config.home.username}";
                      homeDirectory = "${config.home.homeDirectory}";
                    };
                  }
                ];
              }).options
            '';
          };
        };

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
      features.edit_prediction_provider = "none";
      title_bar = {
        show_onboarding_banner = false;
        show_user_picture = false;
        show_sign_in = false;
      };
      ui_font_family = "Nunito";
      buffer_font_family = "Mochie Iosevka";
    };
  };
}
