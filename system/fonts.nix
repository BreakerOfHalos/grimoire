{
  lib,
  pkgs,
  ...
}:
# let
#   pragmata-pro         = pkgs.callPackage ./pragmata-pro {inherit pkgs;};
#   pragmata-pro-mono    = pkgs.callPackage ./pragmata-pro-mono {inherit pkgs;};
#   pragmata-pro-fraktur = pkgs.callPackage ./pragmata-pro-fraktur {inherit pkgs;};
#   sys-font             = pkgs.callPackage ./sys-font {inherit pkgs;};
# in
{
  environment.sessionVariables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofilter:no-stem-darkening=0";
  fonts = {
    
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
      defaultFonts = {
        monospace = [ "Hack" "Noto Color Emoji" ];
        sansSerif = [ "Lexend" "Noto Color Emoji" ];
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    packages = builtins.attrValues {
      inherit (pkgs)
        corefonts

        source-sans
        source-serif

        dejavu_fonts
        inter
        lexend
        roboto
        work-sans
        comic-neue
        twemoji-color-font
        comfortaa
        lato
        jost
        hack-font

        noto-fonts

        # fonts for non-latin languages
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        # install some emoji fonts
        noto-fonts-color-emoji
        material-icons
        material-design-icons

        # pragmata-pro
        # pragmata-pro-fraktur
        # pragmata-pro-mono
        # sys-font
        ;

      inherit (pkgs.nerd-fonts) symbols-only;
    };
  };
}
