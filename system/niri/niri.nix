{ lib
, pkgs
, config
, ... }:
let
  cfg = config.grimoire.gui;
in
{
  options = {

  };

  config = lib.mkIf cfg.enable {
    # PAM settings in g/modules/nixos/security.nix

    services = {
      displayManager = {
        defaultSession = "niri";
        sessionPackages = lib.mkForce [ pkgs.niri ];
      };

      gnome = {
        glib-networking.enable = true;

        # Using the newer gcr instead of gnome-keyring
        # gcr-ssh-agent.enable = true;

        # Using standard keyring to see if this helps
        gnome-keyring.enable = true;

        # GNOME assisstive tech framework
        at-spi2-core.enable = true;

        # simply unneccessary
        gnome-remote-desktop.enable = lib.mkForce false;
      };
    };

    environment = {
      systemPackages = [
        pkgs.niri
        pkgs.xwayland-satellite
      ];
    };

    systemd = {
      user = {
        services.niri-flake-polkit = {
          description = "PolicyKit Authentication Agent provided by niri-flake";
          wantedBy = [ "niri.service" ];
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # config.common = {
      #   default = [ "gtk" "gnome" ];
      #   "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      #   "org.freedesktop.impl.portal.Screenshot" = "gnome";
      # };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config =
        let
          common = {
            default = [ "gnome" "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          };
        in
        {
          inherit common;
          niri = common;
        };
      configPackages = [ pkgs.niri ];
    };
  };
}