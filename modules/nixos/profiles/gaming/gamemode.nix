{ lib
,  config
,  ... }:
let
  cfg = config.grimoire.profiles.gaming.gamemode;
in
{
  options.grimoire.profiles.gaming.gamemode.enable = lib.mkEnableOption "Gamemode" // {
    default = config.grimoire.profiles.gaming.enable;
  };

  config.programs.gamemode = lib.mkIf cfg.enable {
    enable = true;
    enableRenice = true;

    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
    };
  };
}