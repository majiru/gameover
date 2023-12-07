{ lib
, stdenv
, fetchFromGitHub
, rgbds
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "pokegold";
  version = "unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokegold";
    rev = "f69e256d60fa633c6d7a976590018fbe60a02adc";
    hash = "sha256-B1NT7unkxlGwdajiWGV9jpAD4mXXzf/pH8P0YvAHyDw=";
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
    description = "Pokemon Gold/SIlver decomp";
    homepage = "https://github.com/pret/pokegold/";
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };
}
