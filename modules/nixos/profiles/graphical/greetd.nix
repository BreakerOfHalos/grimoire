{ lib
, pkgs
, config
, ... }:
let
  cfg = config.grimoire.profiles.graphical;
in
{
  config = lib.mkIf cfg.enable {
    # Enabling greetd as the display manager
    services.greetd = {
      enable = true;
      vt = 2;
      restart = true;

      settings = {
        default_session = {
          user = "greeter";
          command = lib.concatStringsSep " " [
            (lib.getExe pkgs.greetd.tuigreet)
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--cmd niri-session"
            "--greeting 'Speak friend and enter'"
          ];
        };
      };
    };
  };
}