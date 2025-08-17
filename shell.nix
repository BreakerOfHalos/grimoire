let 
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkshell {
  nativeBuildInputs = builtins.attrValues {
    inherit (pkgs)
      git

  };
}