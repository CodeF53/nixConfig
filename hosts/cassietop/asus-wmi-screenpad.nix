{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  kernel,
}:

let
  kernelVersion =
    with lib;
    let
      versionParts = splitString "." kernel.version;
      major = head versionParts;
      minor = elemAt versionParts 1;
    in
    "${major}.${minor}";

  kernelSources = {
    "asus-wmi.c" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-wmi.c?h=linux-${kernelVersion}.y";
      sha256 = "sha256-itRfuzJoI7hjWwxUP/1YiZYtxJ7r2CkQWJn8r0XWUhM=";
    };
    "asus-wmi.h" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-wmi.h?h=linux-${kernelVersion}.y";
      sha256 = "sha256-WcTmzV8SvlmYUAbdnk/3CMu+VAH9Qy05FUowblbFLu8=";
    };
    "asus-nb-wmi.c" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-nb-wmi.c?h=linux-${kernelVersion}.y";
      sha256 = "sha256-4cSWqLWHhkl4xyXymPXOm1p7AuxgA0GYP/9PQLIg7hA=";
    };
  };
in
stdenv.mkDerivation {
  pname = "asus-wmi-screenpad";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/joyfulcat/asus-wmi-screenpad/archive/master.zip";
    sha256 = "sha256-CN7+48EfKWJv1XP2Zq8JK+vULAxxji4fq7PaNfFL3MI=";
  };

  nativeBuildInputs = [ kernel ];

  postUnpack = ''
    cp ${kernelSources."asus-wmi.c"} $sourceRoot/asus-wmi.c
    cp ${kernelSources."asus-wmi.h"} $sourceRoot/asus-wmi.h
    cp ${kernelSources."asus-nb-wmi.c"} $sourceRoot/asus-nb-wmi.c
  '';

  patchPhase = ''
    patch -p1 < "patch6.11"
  '';

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp asus-wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
    cp asus-nb-wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';
}
