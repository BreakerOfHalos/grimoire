{ lib
, pkgs
, config
, ... }:
let
  sources = import ../../npins;
  lib = import "${sources.nixpkgs}/lib";
in
{
  nixpkgs.config = {
    allowInsecurePredicate =
      pkg:
      let
        pname = lib.getName pkg;
        byName = builtins.elem pname [
          "nix" 
          "lix"
          "mono"
        ];
      in
      if byName then lib.warn "Allowing insecure package: ${pname}" true else false;
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    allowVariants = false;
    allowBroken = false;
    permittedInsecurePackages = [ "mono-5.20.1.34" ];
    allowUnsupportedSystems = true;
    allowAliases = false;
    flake.source = sources.nixpkgs;
    overlays = [
      (
        final: prev: {
          npins = final.callPackage (
            sources.npins {
              pkgs = final;
            } + "/npins.nix"
          ) {};
        }
      )
    ];
  };
}
