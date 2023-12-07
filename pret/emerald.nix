{ lib
, stdenv
, fetchFromGitHub
, libpng
, pkg-config
, devkitpro
}:

stdenv.mkDerivation {
  pname = "pokeemerald";
  version = "unstable-2023-12-2";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokeemerald";
    rev = "e4149e83f89b8b86478e03b8112c1d1e922e65a6";
    hash = "sha256-g6A+STo5sPbDuJoDD7dY4jelQJoDiaDG71e0Vx8ZPuw=";
  };

  nativeBuildInputs = [
    pkg-config
    devkitpro
  ];

  buildInputs = [
    libpng
    devkitpro
  ];

  enableParallelBuilding = true;
  strictDeps = true;
  makeFlags = [ "DEVKITPRO=${devkitpro}" "DEVKITARM=${devkitpro}/devkitARM" ];
  buildFlags = [ "modern" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/rom
    cp pokeemerald_modern.gba $out/rom/pokeemerald.gba

    runHook postInstal
  '';

  meta = {
    description = "Pokemon Emerald Decompilation";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
