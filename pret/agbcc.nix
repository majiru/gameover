{ lib
, stdenv
, fetchFromGitHub
, pkgsCross
, bash
}:

stdenv.mkDerivation {
  pname = "agbcc";
  version = "unstable-2023-9-3";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "agbcc";
    rev = "bfa92a1c98ce039a7df833beefa612fea65d3874";
    hash = "sha256-yQ4k2gkc8TwPBxHnXvpD0hqv19QP2CAnQMiFZv9Sje0=";
  };

  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
    "-Wno-error=format-security"
  ];


  nativeBuildInputs = [ pkgsCross.arm-embedded.buildPackages.binutils ];
  enableParallelBuilding = true;
  strictDeps = true;

  patchPhase = ''
    runHook prePatch

    substituteInPlace libc/Makefile --replace "/bin/bash" "${bash}/bin/bash"

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ./install.sh $out

    runHook postInstal
  '';

  meta = {
    description = "agbcc";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
