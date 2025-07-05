{ lib
, pkgs
, config
, ...
}:
{
  imports = [
    ./dconf.nix
  ];

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

  file = {
    xdg_config = {
      fish.target = ./fish;
      helix.target = ./helix;
      hypr.target = ./hypr;
      mako.target = ./mako;
      niri.target = ./niri;
      quickshell.target = ./quickshell;
      starship.target = ./starship/starship.toml;
      yazi.target = ./yazi;
    };
  };
}

