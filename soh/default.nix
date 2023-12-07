{ stdenv
, lib
, fetchgit
, makeDesktopItem
, copyDesktopItems
, cmake
, ninja
, makeWrapper
, python3
, llvmPackages
, xorg
, glew
, SDL2
, SDL2_net
, imagemagick
, libpulseaudio
, libpng
, bzip2
, StormLib
, lsb-release
, boost

, romVariant ? "debug"
, requireFile
, ootRom ? requireFile {
    name = "oot-${romVariant}.z64";
    message = ''
      This nix expression requires that oot-${romVariant}.z64 is already part of the store.
      To get this file you can dump your Ocarina of Time's cartridge to a file,
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      Note that if you are not using the debug version of the rom you will need to overwrite
      the romVariant attribute with "pal-gc", the only other supported variant as of writing this.
    '';
    sha256 = {
      debug = "94bdeb4ab906db112078a902f4477e9712c4fe803c4efb98c7b97c3f950305ab";
      pal-gc = "f788793d27aac3f8d91be5f242c4134217c615bfddd5c70384521ea2153435d2";
    }.${romVariant};
  }

  # They fetch this in the cmake files from HEAD, we vendor it here
, fetchurl
, controllerdb ? fetchurl {
    url = "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/da332bb484c2434269b9264f7dce3e6114227755/gamecontrollerdb.txt";
    sha256 = "21af43775a2cf92b67819d2e8f4c231a8b64fb963186ce9f0d1c4b099001c084";
  }
}:

stdenv.mkDerivation {
  pname = "shipwright";
  version = "8.0.3";

  src = fetchgit {
    url = "https://github.com/HarbourMasters/Shipwright.git";
    rev = "8.0.3";
    sha256 = "sha256-khbfVzoMW10jbPzf4Ib9adFe3LNBFb4twGkh9ELgE90=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  # Many warnings are being treated as errors
  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
    "-Wno-error=format-security"
  ];

  nativeBuildInputs = [
    python3
    llvmPackages.bintools
    copyDesktopItems
    makeWrapper
    cmake
    ninja
    lsb-release
    imagemagick
  ];

  buildInputs = [
    xorg.xrandr
    xorg.libX11
    glew
    SDL2
    SDL2_net
    libpulseaudio
    libpng
    bzip2
    StormLib
    boost
  ];

  postPatch = ''
    sed -i '/CURL/d' soh/CMakeLists.txt
  '';

  patches = [
    ./soh-home.patch
  ];

  configurePhase = ''
    # Used for asset extraction
    ln -s ${ootRom} OTRExporter/oot.z64

    cmake -H. -Bbuild-cmake -GNinja
    cmake --build build-cmake --target ExtractAssets
  '';

  buildPhase = ''
    cmake --build build-cmake --config Release
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share/pixmaps}
    cp build-cmake/soh/soh.elf build-cmake/soh/*.otr $out/lib
    cp build-cmake/sohIcon.png $out/share/pixmaps/soh.png
    cp ${controllerdb} $out/lib/gamecontrollerdb.txt
    makeWrapper $out/lib/soh.elf $out/bin/soh --set SHIP_BIN_DIR "$out/lib"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "soh";
      icon = "soh";
      exec = "soh";
      genericName = "Ship of Harkinian";
      desktopName = "soh";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/HarbourMasters/Shipwright";
    description = "A PC port of Ocarina of Time with modern controls, widescreen, high-resolution, and more";
    longDescription = ''
      An PC port of Ocarina of Time with modern controls, widescreen, high-resolution and more, based off of decompilation.
      Note that you must supply an OoT rom yourself to use this package because propietary assets are extracted from it.
      Currently only the "debug" and "pal-gc" variants of the rom are supported upstream.
      You can change the target variant like this: shipwright.override { romVariant = "pal-gc"; }
    '';
    mainProgram = "soh";
    platforms = platforms.linux;
    maintainers = [ maintainers.ivar ];
    license = with licenses; [
      # OTRExporter, OTRGui, ZAPDTR, libultraship
      mit
    ];
  };
}
