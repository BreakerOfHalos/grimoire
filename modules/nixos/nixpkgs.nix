{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    allowVariants = false;
    allowBroken = false;
    permittedInsecurePackages = [ ];
    allowUnsupportedSystems = true;
    allowAliases = false;
  };
}
