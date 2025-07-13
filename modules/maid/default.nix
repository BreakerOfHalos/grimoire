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
      alacritty.source = ./alacritty;
      anyrun.source = ./anyrun;
      bat.source = ./bat;
      btop.source = ./btop;
      fastfetch.source = ./fastfetch;
      firefox.source = ./firefox;
      fish.source = ./fish;
      fuzzel.source = ./fuzzel;
      ghostty.source = ./ghostty;
      git.source = ./git;
      helix.source = ./helix;
      hypr.source = ./hypr;
      mako.source = ./mako;
      niri.source = ./niri;
      nushell.source = ./nushell;
      quickshell.source = ./quickshell;
      starship.source = ./starship.toml;
      waybar.source = ./waybar;
      yazi.source = ./yazi;
      zellij.source = ./zellij;
    };
  };
}

