{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokeyellow";
  version = "unstable-2023-11-22";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokeyellow";
    rev = "abc34756d131b327eff548aa13aff8e4b677a96e";
    hash = "sha256-Y2aL5yzxrjPmXlZ9jvxTWMqmqaJD2D4F0PG6vVvimv4=";
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
    description = "Pokemon Yellow decomp";
    homepage = "https://github.com/pret/pokeyellow/";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
