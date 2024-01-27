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
          games.pokecrystal = callPackage (./pret/crystal.nix) { };
          games.pokered = callPackage (./pret/red.nix) { };
          games.shipwright = callPackage (./soh) { };
          games.zelda3 = callPackage (./zelda3) { };
          games.pokeemerald = callPackage (./pret/emerald.nix) { agbcc = games.agbcc; };
          games.pokeinclement = callPackage (./pret/inclement.nix) { agbcc = games.agbcc; };
          games.pokefirered = callPackage (./pret/firered.nix) { agbcc = games.agbcc; };
          games.pokegold = callPackage (./pret/gold.nix) { };
          games.pokeyellow = callPackage (./pret/yellow.nix) { };
          games.agbcc = callPackage (./pret/agbcc.nix) { };
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
