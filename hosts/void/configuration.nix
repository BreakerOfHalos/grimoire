{ lib
, config
, pkgs
, ... }:
{
  imports = [
    ../../modules
    ./void-disk-config.nix
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

      boot.loader = "systemd-boot";
    };
  };

  facter.reportPath = ./facter.json;
}
