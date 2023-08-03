{
  description = "Overlay for closed source / decompiled games";

  inputs = {
    nixpkgs.url = "nixpkgs";
    utils.url = "flake-utils";

    pokecrystal = {
      url = "github:pret/pokecrystal";
      flake = false;
    };
    pokered = {
      url = "github:pret/pokered";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    let
      pkgs = pkgs:
        let
          callPackage = pkgs.lib.callPackageWith pkgs;
        in
        rec {
          games.pokecrystal = callPackage (./crystal.nix) { inherit inputs; };
          games.pokered = callPackage (./red.nix) { inherit inputs; };
          games.shipwright = callPackage (./soh.nix) { };
          games.zelda3 = callPackage (./zelda3.nix) { };
          games.devkitpro = callPackage (./devkitpro.nix) { };
          games.pokeemerald = callPackage (./emerald.nix) { devkitpro = games.devkitpro; };
          games.firered = callPackage (./firered.nix) { devkitpro = games.devkitpro; };
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
