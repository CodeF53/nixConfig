{ pkgs, ... }:

let
  yt-dlp-with-plugins = pkgs.python313.withPackages (ps: [
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
