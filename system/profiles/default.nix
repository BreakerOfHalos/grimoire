{lib, ...}:
{
  imports = [
    ./gaming
  ];

  options.grimoire.profiles = {
    gaming.enable = lib.mkEnableOption "Gaming";
  };
}
