{ lib
, pkgs
, config
, ...
}:
{
  imports = [
    ./dconf.nix
    ./firefox
    ./fish
    ./helix
    ./mako
    ./niri
    ./quickshell
    ./screenlocker
    ./starship
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

    file = {
      xdg_config = {
        fish.source = ./fish;
        helix.source = ./helix;
        hypr.source = ./hypr;
        mako.source = ./mako;
        niri.source = ./niri;
        quickshell.source = ./quickshell;
        starship.source = ./starship/starship.toml;
        yazi.source = ./yazi;
      };
    };
  };
}

