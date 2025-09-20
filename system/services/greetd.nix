{
  lib,
  pkgs,
  config,
  ...
}:
let
  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = lib.concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in
{
  services = {
    greetd = {
      enable = true;
      restart = true;

      settings = {
        default_session = {
          user = "greeter";
          command = lib.concatStringsSep " " [
            (lib.getExe pkgs.tuigreet)
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--sessions '${sessionPath}'"
            "--greeting 'Speak friend and enter'"
          ];
        };
      };
    };
  };
}
