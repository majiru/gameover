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
  pname = "pokefirered";
  version = "unstable-2024-1-19";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokefirered";
    rev = "0c17a3b041a56f176f23145e4a4c0ae758f8d720";
    hash = "sha256-q2iWTr4MY2O8XBvl9IzkmGwDXGdnYBRGdMZS9qmFiZQ=";
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
    make SHELL="${runtimeShell}" firered leafgreen firered_rev1 leafgreen_rev1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/rom/
    cp *.gba $out/rom/

    runHook postInstall
  '';

  meta = {
    description = "Pokemon Firered and Leafgreen Decompilation";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
