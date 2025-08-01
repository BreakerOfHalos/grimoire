{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    attrValues
    ;
  inherit (lib.types) listOf str;

  cfg = config.grimoire.system.printing;
in
{
  options.grimoire.system.printing = {
    enable = mkEnableOption "printing";

    extraDrivers = mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = "A list of additional drivers to install for printing";
    };
  };

  config = mkIf cfg.enable {
    # enable cups and some drivers for common printers
    services = {
      printing = {
        enable = true;

        drivers = attrValues (
          {
            inherit (pkgs) gutenprint hplip brlaser;
          }
          // cfg.extraDrivers
        );
      };

      # required for network discovery of printers
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
