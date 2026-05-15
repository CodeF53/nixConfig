{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.opencode ];
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };
  # todo homemanager this somehow https://github.com/p-lemonish/ollama-x-opencode
}
