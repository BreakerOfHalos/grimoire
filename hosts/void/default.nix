{ 
  lib,
  config,
  modulesPath,
  pkgs,
  ... 
}:
{
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  gui.niri.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      extraPackages = builtins.attrValues {
        inherit (pkgs)
          intel-compute-runtime
          intel-media-driver
          libva
          libvdpau-va-gl
          vpl-gpu-rt
          ;        
      };
    }; 
  };
}
