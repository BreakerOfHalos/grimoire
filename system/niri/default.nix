{ pkgs
, lib
, ...
}:
{
  imports = [ 
    ./niri.nix
  ];

  programs = {
    # Enable our chosen window manager
    # niri.enable = true;
          
    # We need dconf to interact with gtk
    dconf.enable = true;

    # GNOME's keyring manager
    seahorse.enable = true;

    # And a screen locker
    hyprlock.enable = true;

    waybar = {
      enable = true;
      systemd.target = "niri-session";
    };
  };

  services = {
    greetd = {
      enable = true;
      vt = 2;
      restart = true;

      settings = {
        default_session = {
          user = "greeter";
          command = lib.concatStringsSep " " [
            (lib.getExe pkgs.greetd.tuigreet)
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--cmd niri-session"
            "--greeting 'Speak friend and enter'"
          ];
        };
      };
    };

    # We need something to manage idle, and hypridle seems fine.
    hypridle.enable = true;      

    # Disable chrony in favor of systemd-timesyncd
    timesyncd.enable = lib.mkDefault true;
    chrony.enable = lib.mkDefault false;

    # Enable GVFS a userspace virtual filesystem
    gvfs.enable = true;

    # Storage daemon required for udiskie auto-mount
    udisks2.enable = true;

    udev.packages = [ pkgs.gnome-settings-daemon ];

    dbus = {
      enable = true;
      # Use the faster dbus-broker instead of the classic dbus-daemon
      implementation = "broker";

      packages = builtins.attrValues { inherit (pkgs) dconf gcr udisks2; };
    };
  };
}