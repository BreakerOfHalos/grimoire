{ lib
, pkgs
, config
, ...
}:
let
  sys = config.grimoire.system.boot;
  sources = ../../npins;
  lanzaboote = sources.lanzaboote;
in
{
  # https://wiki.nixos.org/wiki/Secure_Boot
  # Secure Boot, my love keeping my valorant working on windows
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  options.grimoire.system.boot.secureBoot = lib.mkEnableOption ''
    secure-boot and load necessary packages, say good bye to systemd-boot
  '';

  config = lib.mkIf sys.secureBoot {
    grimoire.packages = { inherit (pkgs) sbctl; };

    # Lanzaboote replaces the systemd-boot module.
    boot.loader.systemd-boot.enable = mkForce false;

    boot = {
      bootspec.enable = true;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
}