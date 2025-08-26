{ lib
, config
, pkgs
, ... }:
{
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
          libdpau-va-gl
          vpl-gpu-rt
          ;        
      };
    }; 
  };
}
