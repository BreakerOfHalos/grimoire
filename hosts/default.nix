let
  sources = import ../npins;
  pkgs = import ../packages;
in
(
  { modules }:
  import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    modules = [
      {
        config.nixpkgs.pkgs = pkgs;
      }
      ../modules/nixos
      (import sources.nix-maid).nixosModules.default
    ] ++ modules;
  }
)
