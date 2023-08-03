{ lib
, stdenv
, fetchFromGitHub
, rgbds
}:

stdenv.mkDerivation {
  pname = "pokered";
  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokered";
    rev = "a38c7922dda3b6650a1dfe0fe544175ded259b19";
    hash = "sha256-rQrfLCxNG9xirlWLemJ8KWUAxuriq6GN2ivAZauTcmQ=";
  };

  strictDepts = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ rgbds ];

  installPhase = ''
    mkdir -p $out/rom/
    cp poke*.gbc $out/rom/
  '';

  meta = with lib; {
    description = "pokemon red/blue decomp";
    homepage = "https://github.com/pret/pokered/";
    maintainers = with maintainers; [ moody ];
  };
}
