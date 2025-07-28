{ lib
, pkgs
, config
, ...
}:
{
  imports = [
    ./dconf.nix
  ];

  users.users.breakerofhalos.maid = { 
    file = {
      xdg_config = {
        alacritty.source = ./alacritty;
        anyrun.source = ./anyrun;
        bat.source = ./bat;
        btop.source = ./btop;
        fastfetch.source = ./fastfetch;
        # firefox.source = ./firefox;
        fish.source = ./fish;
        fuzzel.source = ./fuzzel;
        ghostty.source = ./ghostty;
        git.source = ./git;
        helix.source = ./helix;
        hypr.source = ./hypr;
        mako.source = ./mako;
        niri.source = ./niri;
        nushell.source = ./nushell;
        # quickshell.source = ./quickshell;
        starship.source = ./starship.toml;
        waybar.source = ./waybar;
        # yazi.source = ./yazi;
        # zellij.source = ./zellij;
        "nushell/nix-your-shell.nu".source = pkgs.nix-your-shell.generate-config "nu";
      };
    };
  };
}

