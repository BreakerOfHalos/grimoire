{
  lib,
  pkgs,
  grimoireLib,
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

  environment.systemPackages = with pkgs; [
    # CLI base tools
      uutils-coreutils-noprefix
  ];

  programs = {
    steam = {
      enable = prof.gaming.enable;
    };

    direnv.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";

    # defaults to 50
    memoryPercent = 90;
  };

  boot.kernel.sysctl = lib.mkIf config.zramSwap.enable {
    # zram is relatively cheap, prefer swap
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    # zram is in memory, no need to readahead
    "vm.page-cluster" = 0;
  };

  environment = {
    variables = grimoireLib.xdg-template.global;
    sessionVariables = grimoireLib.xdg-template.user grimoireLib.xdg-template.simple;
  };
}
