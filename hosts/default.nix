let
  sources = import ../npins;
  pkgs = import ../packages;
in
(
  { modules, config }:
  import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    system = null;
    modules = [
      {
        config.nixpkgs.pkgs = pkgs;
      }
      ../modules/nixos
      (import sources.nix-maid).nixosModules.default
    ] ++ modules;
  }
)
