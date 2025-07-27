{ lib
, pkgs
, config
, ... }:
let
  cfg = config.grimoire.profiles.graphical;
in
{
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
      variables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };

      systemPackages = [
        pkgs.libnotify
        pkgs.xdg-utils
        pkgs.niri
        pkgs.usbutils
        pkgs.pciutils
        pkgs.xwayland-satellite
        pkgs.nautilus
        pkgs.tokyonight-gtk-theme
        pkgs.nordzy-cursor-theme
      ];
    };

    systemd = {
      services.seatd = {
        enable = true; 
        description = "Seat management daemon";
        script = "${lib.getExe pkgs.seatd} -g wheel";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "1";
        };
        wantedBy = [ "multi-user.target" ];
      };

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

    hardware = {
      graphics = {
        enable = true;
        extraPackages = [
          pkgs.vpl-gpu-rt
        ];
      };
    };
  };
}