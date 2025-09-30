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
      yazi
      yt-dlp

      # utilities
      age-plugin-1p
      anyrun
      chezmoi
      fuzzel
      mako
      megasync
      megatools
      mullvad-vpn
      nil
      nixfmt
      quickshell
      wl-clipboard

      # gui essentials
      _1password-gui
      flameshot
      fluffychat
      ghostty
      librewolf
      morgen
      mpv
      obs-studio
      obsidian
      orca-slicer
      signal-desktop
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
