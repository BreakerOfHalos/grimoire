let
  sources = import ../npins;
  pkgs = import ../packages;
in
(
  { modules }:
  {
    modules = [
      {
        config.nixpkgs.pkgs = pkgs;
      }
      ../modules/nixos;
      (import sources.nix-maid).nixosModules.default
    ] ++ modules;
  }
)
