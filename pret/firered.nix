{ lib
, stdenv
, fetchFromGitHub
, libpng
, pkg-config
, devkitpro
}:

stdenv.mkDerivation {
  pname = "pokefirered";
  version = "unstable-2023-12-07";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokefirered";
    rev = "1d1754d37f7a2e6abfe5a5b9351d4d909e6e5f8d";
    hash = "sha256-y0s8SSXD0qEZijyjc/sZ/zv+r1wRYLcxJnROGjcWIFc=";
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
  buildFlags = [ "modern" "leafgreen_modern" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/rom
    cp poke*_modern.gba $out/rom/

    runHook postInstal
  '';

  meta = {
    description = "Pokemon Emerald Decompilation";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.linux;
  };
}
