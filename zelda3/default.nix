{ lib
, stdenv
, fetchFromGitHub
, python3
, SDL2
, makeWrapper
, requireFile

, rom ? requireFile {
    name = "zelda3.sfc";
    message = ''
      This nix expression requires that zelda3.sfc is already part of the store.
      To get this file you can dump your Zelda 3 - A link to the past cartridge to a file,
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "66871d66be19ad2c34c927d6b14cd8eb6fc3181965b6e517cb361f7316009cfb";
  }
}:
let
  mypython = python3.withPackages (pkgs: with pkgs; [
    pillow
    pyyaml
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zelda3";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "snesrev";
    repo = "zelda3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jKCLZ8lqvkN6OmYTZtjxXgbeUUnzOtYaeWmc4rCwwF0=";
  };

  nativeBuildInputs = [
    mypython
    SDL2
    makeWrapper
  ];

  buildInputs = [
    SDL2
  ];

  patches = [
    ./zelda3-home.patch
  ];

  preBuild = ''
    ln -s ${rom} zelda3.sfc
  '';
  buildFlags = [ "PYTHON=${mypython}/bin/python3" ];

  installPhase = ''
    mv zelda3 zelda3.unwrapped
    install -Dm755 -t $out/bin zelda3.unwrapped
    install -Dm644 -t $out/data zelda3_assets.dat
    install -Dm644 -t $out/data zelda3.ini
    makeWrapper $out/bin/zelda3.unwrapped $out/bin/zelda3 \
      --set Z3DAT $out/data/zelda3_assets.dat --set Z3INI $out/data/zelda3.ini
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  meta = {
    description = "A reimplementation of Zelda 3 A Link To The Past";
    homepage = "https://github.com/snesrev/zelda3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moody ];
  };
})
