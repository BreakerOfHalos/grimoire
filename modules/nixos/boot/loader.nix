{ lib
, pkgs
, config
, ... }:
{
  boot.loader = {
    timeout = lib.mkForce 2;
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 15;
      consoleMode = lib.mkDefault "max";
    };
  };
}
