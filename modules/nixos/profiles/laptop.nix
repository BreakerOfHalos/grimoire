{
  lib,
  pkgs,
  config,
  ...
}:
let
  MHz = x: x * 1000;
in
{
  config = lib.mkIf config.grimoire.profiles.laptop.enable {
    # superior power management, littrally saves this crummy laptop
    # you have no clue how annoying it is when I have to update this on nixpkgs
    # if you cannot figure out what is happening here its worth reading the example
    # <https://github.com/AdnanHodzic/auto-cpufreq/#example-config-file-contents>
    services = {
      auto-cpufreq = {
        enable = true;

        settings = {
          battery = {
            governor = "powersave";
            energy_performance_preference = "power";
            scaling_min_freq = mkDefault (MHz 1200);
            scaling_max_freq = mkDefault (MHz 1800);
            turbo = "never";

            # this enables charging thresholds, this means that the battery will only
            # charge when it's above the start_threshold and stop charging when it's
            # below the stop_threshold
            enable_thresholds = true;
            start_threshold = 20;
            stop_threshold = 80;
          };

          charger = {
            governor = "performance";
            energy_performance_preference = "performance";
            scaling_min_freq = mkDefault (MHz 1800);
            scaling_max_freq = mkDefault (MHz 3800);
            turbo = "auto";
          };
        };
      };

      # enabled by default by cosmic and some other DE's
      power-profiles-daemon.enable = false;
    };

    # pretty much handled by brightnessctl
    hardware.acpilight.enable = false;

    # DBus service that provides power management support to applications.
    services.upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "Hibernate";
    };

    services.undervolt = {
      enable = config.grimoire.device.cpu == "intel";
      tempBat = 65; # deg C
      package = pkgs.undervolt;
    };

    # handle ACPI events
    services.acpid.enable = true;

    grimoire.packages = { inherit (pkgs) acpi powertop; };

    boot = {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    services.libinput = {
      enable = true;

      # disable mouse acceleration (yes im gamer)
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };

      # touchpad settings
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        horizontalScrolling = false;
        disableWhileTyping = true;
      };
    };
  };
}
