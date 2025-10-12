{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # shell tools
      bat
      btop
      eza
      fd
      ffmpeg-full
      fzf
      imagemagick
      jq
      nix-your-shell
      nushell
      poppler
      resvg
      ripgrep
      starship
      tealdeer
      zoxide

      # cli/tui programs
      _1password-cli
      aerc
      discordo
      feh
      glow
      helix
      hyfetch
      iamb
      imv
      spotify-player
      yazi
      yt-dlp

      # utilities
      age-plugin-1p
      anyrun
      blueberry
      chezmoi
      cliphist
      fuzzel
      mako
      megacmd
      megasync
      mullvad-vpn
      nil
      nixfmt
      pavucontrol
      quickshell
      wl-clipboard

      # gui essentials
      _1password-gui
      firefox
      flameshot
      fluffychat
      ghostty
      libreoffice-fresh
      librewolf
      morgen
      mpv
      obs-studio
      obsidian
      orca-slicer
      signal-desktop
      transmission_4-gtk
      unzip
      zathura
      ;
  } 
  ++ [(pkgs.discord.override { withMoonlight = true; })];

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        librewolf
      '';
      mode = "0755";
    };
  };
}
