{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokecrystal";
  version = "unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokecrystal";
    rev = "9a917e35760210a1f34057ecada2148f1fefc390";
    hash = "sha256-Qv6Zw++fR8DuYtEMeyu1M6Dz6NVey91od+WRxIbUzPc=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ rgbds ];

  installPhase = ''
    mkdir -p $out/rom/
    cp pokecrystal.gbc $out/rom/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Pokemon Crystal decomp";
    homepage = "https://github.com/pret/pokecrystal/";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
