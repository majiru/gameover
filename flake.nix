{
  description = "Overlay for closed source / decompiled games";

  inputs = {
    nixpkgs.url = "nixpkgs";
    utils.url = "flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    let
      pkgs = pkgs:
        let
          callPackage = pkgs.lib.callPackageWith pkgs;
        in
        rec {
          games.pokecrystal = callPackage (./crystal.nix) { };
          games.pokered = callPackage (./red.nix) { };
          games.shipwright = callPackage (./soh.nix) { };
          games.zelda3 = callPackage (./zelda3.nix) { };
          games.devkitpro = callPackage (./devkitpro.nix) { };
          games.pokeemerald = callPackage (./emerald.nix) { devkitpro = games.devkitpro; };
          games.pokefirered = callPackage (./firered.nix) { devkitpro = games.devkitpro; };
          games.pokegold = callPackage (./gold.nix) { };
          games.pokeyellow = callPackage (./yellow.nix) { };
        };
    in
    utils.lib.eachDefaultSystem
      (system: {
        packages = pkgs nixpkgs.legacyPackages.${system};
      })
    // {
      overlays.default = final: prev: pkgs prev;
    };
}
