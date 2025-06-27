{
  lib,
  pkgs,
  ...
}:
let
  prof = config.grimoire.profiles;
in
{
  system.stateVersion = "24.11";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = mkDefault "America/Los_Angeles";
  hardware.bluetooth.enable = lib.mkIf prof.graphical.enable;
  networking.networkmanager.enable = true;
  users.mutableUsers = false;

  environment.systemPackages = with pkgs; lib.mkMerge [

    (lib.mkIf prof.graphical.enable {
      # CLI tools for workstations, not cluster machines
      usbutils
      pciutils
      mako

      # GUI, obvi
      alacritty
      zellij
      tokyonight-gtk-theme
    })
    
    (# CLI base tools
      uutils-coreutils-noprefix
    )
  ];

  programs = {
    steam = {
      enable = prof.gaming.enable;
    };

    direnv.enable = true;
  };

  services.automatic-timezoned = {
    enable = lib.mkIf prof.graphical.enable;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";

    # defaults to 50
    memoryPercent = 90;
  };

  boot.kernel.sysctl = lib.mkIf config.zramSwap.enable {

 lib. 
    # zram is relatively cheap, prefer swap
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    # zram is in memory, no need to readahead
    "vm.page-cluster" = 0;
  };
}
