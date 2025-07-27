let
  sources = import ../npins;
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
      
      # (let
      #   module = import sources.lix-module;
      #   lixSrc = import sources.lixSrc;
      #   in import "${module}/module.nix" { lix = lixSrc; }
      # )
    ];
  }
)
