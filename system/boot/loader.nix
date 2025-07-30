{ lib
, pkgs
, config
, ... 
}:
{
  boot.loader = {
    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 15;
      consoleMode = lib.mkDefault "max";
      editor = false;
    };

    # if set to 0, space needs to be held to get the boot menu to appear
    timeout = mkForce 2;

    # copy boot files to /boot so that /nix/store is not required to boot
    # it takes up more space but it makes my messups a bit safer
    generationsDir.copyKernels = true;

    # we need to allow installation to modify EFI variables
    efi.canTouchEfiVariables = true;
  };
}
