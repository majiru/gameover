{ lib
, stdenv
, inputs
, rgbds
}:

stdenv.mkDerivation {
  pname = "pokecrystal";
  version = "unstable-2023-06-22";

  src = inputs.pokecrystal;

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
