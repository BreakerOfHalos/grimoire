{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkForce
    ;
  greetd-niri = readFile ./greetd-niri.kdl;
  sessionPath = concatStringSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in
{
  services = {
    greetd = {
      enable = true;
      vt = 2;
      restart = true;

      settings = {
        default_session = {
          user = "greeter";
          command = "niri -c ${greetd-niri}";
        };
        initial_session = {
          command = "niri-session";
          user = "heretics"
        };
      };
    };

    gnome = {
      gnome-keyring.enable = true;
      glib-networking.enable = true;
      gnome-remote-desktop.enable = mkForce false;
      at-spi2-core.enable = true;
    };

    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
      libsecret
    ];

    gvfs.enable = true;
    hyperidle.enable = true;
  };

  programs = {
    regreet = {
      enable = true;
      theme = {
        package = pkgs.toykonight-gtk-theme;
        name = "Tokyonight-Dark";
      };
      iconTheme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Dark-Cyan";
      };
      cursorTheme = {
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
      };
      settings = {
        background.path = "~/Pictures/wallpapers/estradiol.png";
        widget.clock.format = "%a %Y-%m-%d %H:%M";
        appearance.greeting_msg = "Yippe-ki-yay, motherfucker.";
      };
    };

    
    niri.enable = true;
    dconf.enable = true;
    seahorse.enable = true;

    hyperlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          immediate_render = true;
          hide_cursor = false;
        };

        background = [
          {
            monitor = "";
            path = "~/Pictures/wallpapers/estradiol.png";
            blur_passes = 3;
            blur_size = 12;
            noise = "0.1";
            contrast = "1.3";
            brightness = "0.2";
            vibrancy = "0.5";
            vibrancy_darkness = "0.3";
          }
        ];

        input-field = [
          {
            monitor = "";

            size = "300, 50";
            valign = "bottom";
            position = "0%, 10%";

            outline_thickness = 1;

            font_color = "rgb(211, 213, 202)";
            outer_color = "rgba(29, 38, 33, 0.6)";
            inner_color = "rgba(15, 18, 15, 0.1)";
            check_color = "rgba(141, 186, 100, 0.5)";
            fail_color = "rgba(229, 90, 79, 0.5)";

            placeholder_text = "Enter Password";

            dots_spacing = 0.2;
            dots_center = true;
            dots_fade_time = 100;

            shadow_color = "rgba(5, 7, 5, 0.1)";
            shadow_size = 7;
            shadow_passes = 2;
          }
        ];

        label = [
          {
            monitor = "";
            text = ''
              cmd[update:1000] echo "<span font-weight='light' >$(date +'%H %M %S')</span>"
            '';
            font_size = 300;
            font_family = "Adwaita Sans Thin";

            color = "rgb(8a9e6b)";

            position = "0%, 2%";

            valign = "center";
            halign = "center";

            shadow_color = "rgba(5, 7, 5, 0.1)";
            shadow_size = 20;
            shadow_passes = 2;
            shadow_boost = 0.3;
          }
        ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    config.common = {
      default = [ "gtk" ];

      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    extraPortals= [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

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
}
