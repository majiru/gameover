{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokered";
  version = "unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokered";
    rev = "f6017ddbfd7e14ea39b81ce3393de9117e7310d9";
    hash = "sha256-mU09W2onabprdheWEt7KqZm/hsBaZ45Xy4FCm26wDr8=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ rgbds ];

  installPhase = ''
    mkdir -p $out/rom/
    cp poke*.gbc $out/rom/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Pokemon Red/Blue decomp";
    homepage = "https://github.com/pret/pokered/";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
