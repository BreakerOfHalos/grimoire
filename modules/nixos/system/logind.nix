{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.grimoire.profiles.graphical.enable {
    services.logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      powerKey = "suspend-then-hibernate";
    };
  };
}
