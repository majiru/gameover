{ lib
, stdenv
, fetchFromGitHub
, libpng
, pkg-config
, agbcc
, bash
, pkgsCross
}:

stdenv.mkDerivation {
  pname = "pokeinclement";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "BuffelSaft";
    repo = "pokeemerald";
    rev = "v1.13";
    hash = "sha256-Lg1N07pDprt2XQhoNFp+2cgoy1SOIei+DUoR2AzLv4g=";
  };

  nativeBuildInputs = [
    pkg-config
    pkgsCross.arm-embedded.buildPackages.binutils
  ];

  buildInputs = [
    libpng
    agbcc
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    cp -r ${agbcc}/tools ./
    make SHELL="${bash}/bin/bash"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/rom
    cp pokeemerald.gba $out/rom/inclementemerald.gba

    runHook postInstal
  '';

  meta = {
    description = "Pokemon Inclement Emerald";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
