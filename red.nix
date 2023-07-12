{ lib
, stdenv
, inputs
, rgbds
}:

stdenv.mkDerivation {
  pname = "pokered";
  version = "unstable-2023-05-10";

  src = inputs.pokered;

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
