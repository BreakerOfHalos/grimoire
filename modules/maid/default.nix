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
    # nheko # currently insecure
    junction
    quickshell
    ghostty
    fuzzel
    ;
  };

  file = {
    xdg_config = {
      fish.source = ./fish;
      helix.source = ./helix;
      hypr.source = ./hypr;
      mako.source = ./mako;
      niri.source = ./niri;
      quickshell.source = ./quickshell;
      starship.source = ./starship.toml;
      yazi.source = ./yazi;
    };
  };
}

