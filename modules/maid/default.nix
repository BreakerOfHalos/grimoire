{ lib
, pkgs
, config
, ...
}:
{
  imports = [
    ./maid.nix
    ./firefox
    ./fish
    ./helix
    ./mako
    ./niri
    ./quickshell
    ./screenlocker
    # ./wallpapers does not get imported because it's just assets
    ./yazi
  ];

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

