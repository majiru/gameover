{ lib
, stdenv
, fetchFromGitHub
, libpng
, pkg-config
, pkgsCross
, agbcc
, runtimeShell
}:

stdenv.mkDerivation {
  pname = "pokeemerald";
  version = "unstable-2024-1-19";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokeemerald";
    rev = "bcd5fc1481dc540d9007f1a82a2862e7d6e7de77";
    hash = "sha256-Gv0uDOsNRCc4QyW4LG14tL51oL7hVh3NvlmWnj/5QbE=";
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
    make SHELL="${runtimeShell}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/rom
    cp pokeemerald.gba $out/rom/pokeemerald.gba

    runHook postInstal
  '';

  meta = {
    description = "Pokemon Emerald Decompilation";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
