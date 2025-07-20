{ lib
, config
, pkgs
, ... }:
{
  imports = [
    ../../modules
    ./void-disk-configuration.nix
  ];

  networking.hostName = "void";

  grimoire = {
    profiles = {
      graphical.enable = true;
      # gaming.enable = true;
    };

    device.capabilities = {
      yubikey = true;
      tpm = true;
     }; 

    system = {
      printing.enable = true;
    };
  };

  config.facter.reportPath = ./facter.json;
}
