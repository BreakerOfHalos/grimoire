{ lib
, pkgs
, config
, ... 
}:
{
  boot.loader.systemd-boot = {
    enable = lib.mkDefault true;
    configurationLimit = 15;
    consoleMode = lib.mkDefault "max";
    editor = false;
  };
}
