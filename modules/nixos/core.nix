{
  lib,
  pkgs,
  ...
}:
let
  prof = config.grimoire.profiles;
in
{
  system.stateVersion = "24.11";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = lib.mkIf prof.graphical.enable;
  networking.networkmanager.enable = true;
  users.mutableUsers = false;

  environment.systemPackages = with pkgs; lib.mkMerge [

    (lib.mkIf prof.graphical.enable {
      # CLI tools for workstations, not cluster machines
      usbutils
      pciutils
      mako

      # GUI, obvi
      alacritty
      zellij
      tokyonight-gtk-theme
    })
    
    (# CLI base tools
      uutils-coreutils-noprefix
    )
  ];

  programs = {
    steam = {
      enable = prof.gaming.enable;
    };

    direnv.enable = true;
  };

  services.automatic-timezoned = {
    enable = lib.mkIf prof.graphical.enable;
  };
}
