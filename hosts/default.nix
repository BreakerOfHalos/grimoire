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
      (import "${sources.lix-module}/module.nix" { lix = sources.lixSrc; })
      # (let
      #   module = import sources.lix-module;
      #   lixSrc = import sources.lixSrc;
      #   in import "${module}/module.nix" { lix = lixSrc; }
      # )
    ];
  }
)
