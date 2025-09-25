{ pkgs, ... }:

let
  nixpkgs-master = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/c3ffe46c059e3a830d9af6fad7d2b51cf4e15026.tar.gz";
    sha256 = "sha256:0rq6hfrs22ik4j20g13q3mcq7ylgnq8bz7w1v62ahil9qjiw2hqm";
  }) { inherit (pkgs) system; };

  yt-dlp-with-plugins = nixpkgs-master.python313.withPackages (ps: [
    ps.yt-dlp
    ps.bgutil-ytdlp-pot-provider
  ]);
in
{
  environment.systemPackages = [
    pkgs.ffmpeg-full
    yt-dlp-with-plugins
  ];

  virtualisation.docker.enable = true;
  virtualisation.oci-containers.containers.bgutil-provider = {
    image = "brainicism/bgutil-ytdlp-pot-provider";
    autoStart = true;
    ports = [ "4416:4416" ];
    extraOptions = [ "--init" ];
  };
}
