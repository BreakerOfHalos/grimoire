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
      fzf
      nix-your-shell
      nushell
      starship
      tealdeer
      zoxide

      # cli/tui programs
      _1password-cli
      aerc
      discordo
      helix
      hyfetch
      imv
      yazi
      yt-dlp

      # utilities
      age-plugin-1p
      anyrun
      chezmoi
      fuzzel
      junction
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
      ghostty
      morgen
      mpv
      #nheko
      obs-studio
      obsidian
      orca-slicer
      signal-desktop
      unzip
      vivaldi
      zathura
      ;
  } 
  ++ [(pkgs.discord.override { withMoonlight = true; })];
}
