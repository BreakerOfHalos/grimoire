{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.discord;

  settingsFormat = pkgs.formats.json { };
in
{
  options.programs.discord = {
    enable = lib.mkEnableOption "discord support";
    package = lib.mkPackageOption pkgs "discord" { };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = "Settings for Discord";
    };

    moonlight = {
      enable = lib.mkEnableOption "Moonlight support for Discord";

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        default = { };
        description = "Settings for Moonlight";
      };
    };

    vencord = {
      enable = lib.mkEnableOption "Vencord support for Discord";

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        default = { };
        description = "Path to Vencord settings file";
      };
    };
  };

  config = 
    let
      finalPackage = pkgs.discord.override {
        withMoonlight = cfg.moonlight.enable;
        withVencord = cfg.vencord.enable;
      };
    in
    lib.mkIf cfg.enable (lib.mkMerge [
    ({
      environment.systemPackages = [ finalPackage ];

      xdg.configFile = {
        "discord/settings.json".source = settingsFormat.generate "discord-settings.json" cfg.settings;
      };
    })

    (lib.mkIf cfg.moonlight.enable {
      xdg.configFile = {
        "moonlight-mod/stable.json".source =
          settingsFormat.generate "moonlight-settings.json" cfg.moonlight.settings;
      };
    })

    (lib.mkIf cfg.vencord.enable {
      xdg.configFile = {
        "Vencord/settings/settings.json".source =
          settingsFormat.generate "vencord-settings.json" cfg.vencord.settings;
      };
    })
  ]);
}