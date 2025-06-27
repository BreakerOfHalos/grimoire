{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    getExe
    mkOption
    mkOptionDefault
    concatStringsSep
    ;
  inherit (lib.types) nullOr enum;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  cfg = config.grimoire.environment.loginManager;
in
{
  options.grimoire.environment.loginManager = mkOption {
    type = nullOr (enum [
      "greetd"
    ]);
    description = "The login manager to be used by the system.";
  };

  config = mkMerge [
    {
      grimoire.environment.loginManager = mkOptionDefault (
        if config.grimoire.profiles.graphical.enable then "greetd" else null
      );
    }

    (mkIf (cfg == "greetd") {
      services.greetd = {
        enable = true;
        vt = 2;
        restart = true;

        settings = {
          default_session = {
            user = "greeter";
            command = concatStringsSep " " [
              (getExe pkgs.greetd.tuigreet)
              "--time"
              "--remember"
              "--remember-user-session"
              "--asterisks"
              "--sessions '${sessionPath}'"
            ];
          };
        };
      };
    })
  ];
}
