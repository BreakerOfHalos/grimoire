let
  sources = import ../npins;
  pkgs = import ../packages;
in
(
  { config, ... }:
  {
    imports = [
      {
        config.nixpkgs.pkgs = pkgs;
      }
      ../modules/nixos
      (import sources.nix-maid).nixosModules.default
    ];
  }
)
