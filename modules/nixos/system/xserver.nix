{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mergeAttrsList optionalAttrs;
in
{
  config = mkIf (config.grimoire.profiles.graphical.enable && !config.grimoire.profiles.gaming.enable) {
    services.xserver = {
      enable = false;
      desktopManager.xterm.enable = false;

      excludePackages = [ pkgs.xterm ];
    };
  };
}
