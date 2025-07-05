{ lib
, config
, pkgs
, ... }:
let
  inherit (lib) mkIf mkMerge genAttrs;

  services = [
    "login"
    "greetd"
    "tuigreet"
    "regreet"
  ];

  mkService = {
    enableGnomeKeyring = true;
    gnupg = {
      enable = true;
      noAutostart = true;
      storeOnly = true;
    };
  };
in
{
  security.pam = mkMerge [
    {
      # fix "too many files open" errors while writing a lot of data at once
      # was previously a huge issue when rebuilding
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      # allow screen lockers to also unlock the screen
      # (e.g. swaylock, gtklock)
      services = {
        swaylock.text = "auth include login";
        gtklock.text = "auth include login";
        hyprlock.text = "auth include login";
      };
    }

    (mkIf config.grimoire.profiles.graphical.enable {
      services = genAttrs services (_: mkService);
    })
  ];

  security = {
    polkit.enable = true;
    soteria.enable = config.grimoire.graphical.enable;
    protectKernelImage = true;
    lockKernelModules = false; # breaks virtd, wireguard and iptables

    # force-enable the Page Table Isolation (PTI) Linux kernel feature
    forcePageTableIsolation = true;

    # User namespaces are required for sandboxing.
    # this means you cannot set `"user.max_user_namespaces" = 0;` in sysctl
    allowUserNamespaces = true;

    # Disable unprivileged user namespaces, unless containers are enabled
    unprivilegedUsernsClone = false;

    allowSimultaneousMultithreading = true;

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
            ${getExe pkgs.sudo} {
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
