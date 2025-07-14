{
  lib,
  grimoireLib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.grimoire.profiles.graphical;

  cfg.gtk-theme = "Tokyonight-Dark";
  cfg.xcursor = "Nordzy-catppuccin-macchiato-teal";
in
{
  config = mkIf cfg.enable {
    
    environment.sessionVariable = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      GDK_BACKEND = "wayland,x11";
      ANKI_WAYLAND = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

    location.provider = "geoclue2";

    qt = {
      enabme = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    environment.systemPackages = with pkgs; [
      # CLI base tools
      usbutils
      pciutils

      # Themeing and aesthetics
      tokyonight-gtk-theme
      nordzy-cursor-theme

      #GUI
      zellij
      alacritty
      xwayland-satellite
      nautilus # for file picker dialogs
      fuzzel
    ];

    programs = {
      # Enable our chosen window manager
      niri.enable = true;
          
      # We need dconf to interact with gtk
      dconf.enable = true;

      # GNOME's keyring manager
      seahorse.enable = true;

      # We need something to manage idle, and hypridle seems fine.
      hypridle.enable = true;

      # And a screen locker
      hyprlock.enable = true;
      
      regreet = {
        enable = false;
        theme = {
          name = cfg.gtk-theme;
        };
        iconTheme = {
          name = cfg.gtk-theme;
        };
        cursorTheme = {
          name = cfg.xcursor;
        };
        settings = {
          background.path = "~/Pictures/wallpapers/estradiol.png";
          widget.clock.format = "%a %Y-%m-%d %H:%M";
        };
      };

      gtklock = {
        enable = false;
        config = {
          main = {
            gtk-theme = cfg.gtk-theme;
            idle-hide = true;
            idle-timeout = 45;
            follow-focus = true;
            date-format = "%a %Y-%m-%d";
            time-format = "%H:%M";
          };
        };
      };
    };

    services = {

      # Disable chrony in favor of systemd-timesyncd
      timesyncd.enable = lib.mkDefault true;
      chrony.enable = lib.mkDefault false;

      # Enable GVFS a userspace virtual filesystem
      gvfs.enable = true;

      # Storage daemon required for udiskie auto-mount
      udisks2.enable = true;

      udev.packages = [ pkgs.gnome-settings-daemon ];

      gnome = {
        glib-networking.enable = true;

        # Using the newer gcr instead of gnome-keyring
        gcr-ssh-agent.enable = true;

        # GNOME assisstive tech framework
        at-spi2-core.enable = true;

        # simply unneccessary
        gnome-remote-desktop.enable = lib.mkForce false;
      };

      geoclue2 = {
        enable = true;
        geoProviderUrl = "https://beacondb.net/v1/geolocate";
        submissionUrl = "https://beacondb.net/v2/geosubmit";
        submissionNick = "geoclue";

        appConfig.gammastep = {
          isAllowed = true;
          isSystem = false;
        };
      };

      # Enabling greetd as the display manager
      greetd = {
        enable = true;
        vt = 2;
        restart = true;

        settings = {
          default_session = {
            user = "greeter";
            command = concatStringsSep " " [
              (lib.getExe pkgs.greetd.tuigreet)
              "--time"
              "--remember"
              "--remember-user-session"
              "--asterisks"
              "--sessions niri-session"
            ];
          };
        };
      };

      dbus = {
        enable = true;
        # Use the faster dbus-broker instead of the classic dbus-daemon
        implementation = "broker";

        packages = lib.builtins.attrvalues { inherit (pkgs) dconf gcr udisks2; };
      };
    };

    systemd.services.seatd = {
      enable = true; 
      description = "Seat management daemon";
      script = "${getExe pkgs.seatd} -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = [ "multi-user.target" ];
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common = {
        default = [ "gtk" "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
      };
      extraPortals = [
        pkgs.xdg-portal-gtk
        pkgs.xdg-portal-gnome
      ];
    };
  };
}
