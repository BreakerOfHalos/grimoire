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
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    environment.systemPackages = with pkgs; [
      # CLI base tools
      usbutils
      pciutils
      libnotify
      niri

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

    systemd.user = {
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

    programs = {
      # Enable our chosen window manager
      # niri.enable = true;
          
      # We need dconf to interact with gtk
      dconf.enable = true;

      # GNOME's keyring manager
      seahorse.enable = true;

      # We need something to manage idle, and hypridle seems fine.
      hypridle.enable = true;

      # And a screen locker
      hyprlock.enable = true;
      
      # regreet = {
      #   enable = false;
      #   theme = {
      #     name = cfg.gtk-theme;
      #   };
      #   iconTheme = {
      #     name = cfg.gtk-theme;
      #   };
      #   cursorTheme = {
      #     name = cfg.xcursor;
      #   };
      #   settings = {
      #     background.path = "~/Pictures/wallpapers/estradiol.png";
      #     widget.clock.format = "%a %Y-%m-%d %H:%M";
      #   };
      # };

      # gtklock = {
      #   enable = false;
      #   config = {
      #     main = {
      #       gtk-theme = cfg.gtk-theme;
      #       idle-hide = true;
      #       idle-timeout = 45;
      #       follow-focus = true;
      #       date-format = "%a %Y-%m-%d";
      #       time-format = "%H:%M";
      #     };
      #   };
      # };
    };

    services = {

      displayManager = {
        defaultSession = "niri";
        sessionPackages = lib.mkForce [ pkgs.niri ];
      };
      
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
        # gcr-ssh-agent.enable = true;

        # Using standard keyring to see if this helps
        gnome-keyring.enable = true;

        # GNOME assisstive tech framework
        at-spi2-core.enable = true;

        # simply unneccessary
        gnome-remote-desktop.enable = lib.mkForce false;
      };

      geoclue2 = {
        enable = true;
        enableWifi = true;
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
      # config.common = {
      #   default = [ "gtk" "gnome" ];
      #   "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      #   "org.freedesktop.impl.portal.Screenshot" = "gnome";
      # };
      extraPortals = [
        pkgs.xdg-portal-gtk
        pkgs.xdg-portal-gnome
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

    hardware.opengl = {
      enable = true;
      extraPAckages = [
        pkgs.vpl-gpu-rt
      ];
    };
  };
}
