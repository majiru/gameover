{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, zstd
, gcc-unwrapped
}:

# devkitpro kinda sucks and won't
# let us repackage, so we have to pull
# and patch stuff from their pacman repos.
# To find the versions of these packages,
# consult the .db file for the repository
# which is a .tgz with descriptions for
# all the packages:
# https://pkg.devkitpro.org/packages/linux/x86_64/dkp-linux.db
# https://pkg.devkitpro.org/packages/dkp-libs.db
stdenv.mkDerivation (finalAttrs: {
  pname = "devkitpro";
  version = "61-5";

  srcs = [
    # devkitarm
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/linux/x86_64/devkitARM-r${finalAttrs.version}-x86_64.pkg.tar.zst";
      hash = "sha256-pozLv0Ds1bjfLbpCRTkzgkhORnfAHmuDQicGnxNRU5g=";
    })
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/devkitarm-rules-1.5.0-2-any.pkg.tar.zst";
      hash = "sha256-vNHrK5h2vA6LW2DOf8qJJ4lc/3k9uXiFNZ619s37WX8=";
    })
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/devkitarm-crtls-1.2.2-1-any.pkg.tar.zst";
      hash = "sha256-SplC0LbsE6+4QxylA+wQqEOXHlpb2sra0zscM3LIo+U=";
    })

    # GBA
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/linux/x86_64/gba-tools-1.2.0-1-x86_64.pkg.tar.xz";
      hash = "sha256-nzu0/qpcTQSylFMd+UBO1KzqT3NGGkUAHl3/WY6ADeg=";
    })
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/libgba-0.5.2-2-any.pkg.tar.xz";
      hash = "sha256-yoBvzpPk+A1VV3+np800sS+ik0ruaoVdMGwxHJzCyHY=";
    })
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/maxmod-gba-1.0.15-1-any.pkg.tar.xz";
      hash = "sha256-MMO/PjvmnvsSG9KqrLmgDuUd/r4duziE7jKlaaqEdvI=";
    })
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/libfat-gba-1.1.5-1-any.pkg.tar.xz";
      hash = "sha256-sOzyp1GWEFBJ5R4NteecIb7rdVvfjDqRKSpvbeaeA7M=";
    })

    # utils
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/linux/x86_64/mmutil-1.10.1-1-x86_64.pkg.tar.xz";
      hash = "sha256-EL8EdS11FZq5QL9LiA749+xnbx7LcEU1THb7BSxBLds=";
    })
    (fetchurl {
      url = "https://pkg.devkitpro.org/packages/linux/x86_64/general-tools-1.4.4-1-x86_64.pkg.tar.zst";
      hash = "sha256-trWb09ItT4On8GaPdJ33z5ex8FCDAx5inUPKT0N3x7U=";
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    zstd
    gcc-unwrapped
  ];

  installPhase = ''
    mkdir -p $out
    cp -r devkitpro/* $out
  '';

  meta = {
    homepage = "https://devkitpro.org/";
    description = "homebrew toolchain for video game consoles";
    maintainers = with lib.maintainers; [ moody ];
    platforms = [ "x86_64-linux" ];
  };
})
