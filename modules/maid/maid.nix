{ lib
, pkgs
, config
, ...
}:
let
  sources = import ../../npins;
  nix-maid = import sources.nix-maid;
in
{
  imports = [ nix-maid.nixosModules.default ];

  maid = {
    packages = builtins.attrValues {
      inherit (pkgs)
      starship
      zoxide
      eza
      yazi
      fzf
      btop
      hyfetch
      helix
      anyrun
      obsidian
      flameshot
      obs-studio
      morgen
      orca-slicer
      discordo
      moonlight
      nheko
      junction
      quickshell
      ;
    };
  };
}
