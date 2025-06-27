{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) getExe mkDefault;
in
{
  xdg.portal = {
    enable = mkDefault config.grimoire.profiles.graphical.enable;

    # xdgOpenUsePortal = true;

    config.common = {
      default = [ "gtk" ];

      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };
}
