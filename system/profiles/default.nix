{lib, ...}:
{
  imports = [
    ./gaming
    ./graphical
    ./headless.nix
    ./laptop.nix
  ];

  options.grimoire.profiles = {
    graphical.enable = lib.mkEnableOption "Graphical Interface";
    headless.enable = lib.mkEnableOption "Headless";
    gaming.enable = lib.mkEnableOption "Gaming";
  };
}
