{ pkgs
, lib
, ...
}:
{
  imports = [ 
    ./niri.nix
  ];

  programs = {
    # And a screen locker
    hyprlock.enable = true;

    waybar = {
      enable = true;
      systemd.target = "niri-session";
    };
  };

  services = {
    # We need something to manage idle, and hypridle seems fine.
    hypridle.enable = true;
  };
}