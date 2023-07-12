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
        {
          games.pokecrystal = callPackage (./crystal.nix) { inherit inputs; };
          games.pokered = callPackage (./red.nix) { inherit inputs; };
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
