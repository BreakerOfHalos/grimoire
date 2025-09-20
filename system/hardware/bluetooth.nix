{ pkgs, ... }:
{
  hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez;
        powerOnBoot = true;
        disabledPlugins = [ "sap" ];
        settings = {
          General = {
            JustWorksRepairing = "always";
            MultiProfile = "multiple";
          };
        };
      };

  services.blueman.enable = true;
}
