{ inputs, config, pkgs, ... }:

{
  imports = [
  	inputs.zen-browser.homeModules.beta
  	inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  programs.home-manager.enable = true;

  home = {
    username = "cassie";
    homeDirectory = "/home/cassie";
  	stateVersion = "25.05";
  };

  home.packages = with pkgs; [
  	equibop
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

  programs.zen-browser = {
  	enable = true;
  };

  programs.plasma = {
  	enable = true;
  	workspace = {
  	  lookAndFeel = "org.kde.breezedark.desktop";
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
}
