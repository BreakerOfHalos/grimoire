{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # shell tools
      android-tools
      android-udev-rules
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
      manga-tui
      spotify-player
      vhs
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
      swaybg
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
      spotify
      transmission_4-gtk
      unzip
      vesktop
      zathura
      ;
  } ++ [ inputs.helium-browser.packages."${pkgs.system}".helium ]; 

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        librewolf
        helium
      '';
      mode = "0755";
    };
  };
}
