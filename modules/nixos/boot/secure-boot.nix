{ lib
, pkgs
, config
, ...
}:
let
  sys = config.grimoire.system.boot;
  sources = import ../../../npins;
  lanzaboote = import sources.lanzaboote;
in
{
  # https://wiki.nixos.org/wiki/Secure_Boot
  # Secure Boot, my love keeping my valorant working on windows
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  options.grimoire.system.boot.secureBoot = lib.mkEnableOption ''
    secure-boot and load necessary packages, say good bye to systemd-boot
  '';

  config = lib.mkIf sys.secureBoot {
    environment.systemPackages = { inherit (pkgs) sbctl; };

    # Lanzaboote replaces the systemd-boot module.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot = {
      bootspec.enable = true;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
}
