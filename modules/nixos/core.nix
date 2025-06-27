{
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = "24.11";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = lib.mkDefault true;
  networking.networkmanager.enable = true;
  users.mutableUsers = false;

  systemd =
  let
    extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=15s
      DefaultDeviceTimeoutSec=15s
    '';
  in
  {
    inherit extraConfig;
    user = { inherit extraConfig; };
    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
    services."getty@tty7".enable = false;
    services."autovt@tty7".enable = false;
    services."kmsconvt@tty1".enable = false;
    services."kmsconvt@tty7".enable = false;
  };

  environment.systemPackages = with pkgs; [
    # CLI base tools
    usbutils
    pciutils
    uutils-coreutils-noprefix
    mako

    # GUI
    alacritty
    zellij
    tokyonight-gtk-theme
  ];

  programs = {
    steam.enable = true;
    direnv.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
  };
}
