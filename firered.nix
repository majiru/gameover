{ lib
, stdenv
, fetchFromGitHub
, libpng
, pkg-config
, devkitpro
}:

stdenv.mkDerivation {
  pname = "pokefirered";
  version = "unstable-2023-07-29";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokefirered";
    rev = "e180611de6bdf770bad757a9b178c0bb206918e8";
    hash = "sha256-od8IYk+O9UI/TgfyEWgawCS4Rfdsn8+hR4510SRG95w=";
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
