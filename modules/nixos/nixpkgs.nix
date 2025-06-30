let
  sources = import ./npins;
  lib = import "${sources.nixpkgs}/lib";
in
import sources.nixpkgs {
  config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    allowVariants = false;
    allowBroken = false;
    permittedInsecurePackages = [ ];
    allowUnsupportedSystems = true;
    allowAliases = false;
  };

  overlays = [
    (import ./overlays.nix lib)
  ];
}
