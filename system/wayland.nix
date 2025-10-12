{ ... }:
{
  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      DISPLAY = ":0";

      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "niri";

      SDL_VIDEODRIVER = "wayland";

      _JAVA_AWT_WM_NONREPARENTING = "1";

      CLUTTER_BACKEND = "wayland";

      GDK_BACKEND = "wayland";

      QT_QPA_PLATFORM = "wayland";
    };
  };
}
