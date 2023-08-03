{ lib
, stdenv
, fetchFromGitHub
, rgbds
}:

stdenv.mkDerivation {
  pname = "pokecrystal";
  version = "unstable-2023-06-26";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "pokecrystal";
    rev = "768b3bdec15ac9f79e43f88695514494c93f2f99";
    hash = "sha256-NPUJSdXUx/3DBTr5uzZ3DcDXLXHK3BJRlM9p63ULJqw=";
  };

  strictDepts = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ rgbds ];

  installPhase = ''
    mkdir -p $out/rom/
    cp pokecrystal.gbc $out/rom/
  '';

  meta = with lib; {
    description = "pokemon crystal decomp";
    homepage = "https://github.com/pret/pokecrystal/";
    maintainers = with maintainers; [ moody ];
  };
}
