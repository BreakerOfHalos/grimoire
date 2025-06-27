{lib, ...}:
{
  options.grimoire.profiles = {
    graphical.enable = lib.mkEnableOption "Graphical Interface";
    headless.enable = lib.mkEnableOption "Headless";
    gaming.enable = lib.mkEnableOption "Gaming";
    laptop.enable = lib.mkEnableOption "Laptop";
  };
}
