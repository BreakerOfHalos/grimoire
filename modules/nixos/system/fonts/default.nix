{
  lib,
  pkgs,
  ...
}:
let
  pragmata-pro         = pkgs.callPackage ./pragmata-pro {inherit pkgs;};
  pragmata-pro-mono    = pkgs.callPackage ./pragmata-pro-mono {inherit pkgs;};
  pragmata-pro-fraktur = pkgs.callPackage ./pragmata-pro-fraktur {inherit pkgs;};
  sys-font             = pkgs.callPackage ./sys-font {inherit pkgs;};
in
{
  fonts = {
    
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    packages = with pkgs; [ 
      corefonts

      source-sans
      source-serif

      dejavu_fonts
      inter

      noto-fonts

      # fonts for none latin languages
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # install some emoji fonts
      noto-fonts-color-emoji
      material-icons
      material-design-icons
      

      nerd-fonts.symbols-only
      pragmata-pro
      pragmata-pro-fraktur
      pragmata-pro-mono
      sys-font
    ];
  };
}
