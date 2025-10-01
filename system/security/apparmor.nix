{
  lib,
  config,
  pkgs,
  ...
}:
{
  security = {
    apparmor = {
      enable = true;

      # whether to enable the AppArmor cache
      # in /var/cache/apparmore
      enableCache = true;

      # whether to kill processes which have an AppArmor profile enabled
      # but are not confined
      killUnconfinedConfinables = true;

      # packages to be added to AppArmor’s include path
      packages = [ pkgs.apparmor-profiles ];

      # apparmor policies
      policies = {
        "default_deny" = {
          state = "disable";
          profile = ''
            profile default_deny /** { }
          '';
        };

        "sudo" = {
          state = "disable";
          profile = ''
            ${lib.getExe pkgs.sudo} {
              file /** rwlkUx,
            }
          '';
        };

        "nix" = {
          state = "disable";
          profile = ''
            ${lib.getExe config.nix.package} {
              unconfined,
            }
          '';
        };
      };
    };
  };

  services.dbus.apparmor = "disabled";
}
