let
  sources = import ../npins;
  lib = import "${sources.nixpkgs}/lib";
in
import sources.nixpkgs {
  config = {
    allowInsecurePredicate =
      pkg:
      let
        pname = lib.getName pkg;
        byName = builtins.elem pname [
          "nix" "lix"
        ];
      in
      if byName then lib.warn "Allowing insecure package: ${pname}" true else false;
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
