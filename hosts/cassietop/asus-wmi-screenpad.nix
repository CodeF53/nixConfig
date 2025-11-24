{
  lib,
  stdenv,
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
      sha256 = "sha256-VxADtNNSB4Z/xF2DgTD40JtJ8drQPnGd8tfiJVga+So=";
    };
    "asus-wmi.h" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-wmi.h?h=linux-${kernelVersion}.y";
      sha256 = "sha256-LSGQ+zjPf+WV7c8UVngvwTUvM/GEpIieg97echkippU=";
    };
    "asus-nb-wmi.c" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-nb-wmi.c?h=linux-${kernelVersion}.y";
      sha256 = "sha256-SCwF54jdN1zFLpIvOuJq8HkFxoAjwX6dle/eMQmnfms=";
    };
  };
in
stdenv.mkDerivation {
  pname = "asus-wmi-screenpad";
  version = "1.0";

  unpackPhase = ''
    mkdir -p source
    cd source
    cp ${kernelSources."asus-wmi.c"} asus-wmi.c
    cp ${kernelSources."asus-nb-wmi.c"} asus-nb-wmi.c
    cp ${kernelSources."asus-wmi.h"} asus-wmi.h
    echo "obj-m += asus-wmi.o asus-nb-wmi.o" > Makefile
    sourceRoot=.
  '';

  nativeBuildInputs = [ kernel ];

  patchPhase = ''
    patch -p1 < "${./screenpad-patch6.17}"
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
