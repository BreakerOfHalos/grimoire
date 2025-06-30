{ lib
, pkgs
, config
, ...
}:
{
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
