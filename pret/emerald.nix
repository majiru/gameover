{ lib
, stdenv
, fetchFromGitHub
, libpng
, pkg-config
, devkitpro
}:

stdenv.mkDerivation {
  pname = "pokeemerald";
  version = "unstable-2023-07-31";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokeemerald";
    rev = "da238562f01726c786b442dd4b55ec9536f8316a";
    hash = "sha256-j/B6KmVPTgwAxWiFVSIKuZfbr6FL58NVkFhD/qh0JfA=";
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
