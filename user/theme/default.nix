pkgs:
{
  opacity = 1.0;
  background = "1a1b26";

  text = "c0caf5";

  regular = {
    background = "414868";

    blue = "7aa2f7";
    cyan = "7dcfff";
    green = "73daca";
    purple = "bb9af7";
    red = "f7768e";
    white = "c0caf5";
    yellow = "e0af68";
  };

  bright = {
    background = "565f89";

    blue = "7aa2f7";
    cyan = "7dcfff";
    green = "73daca";
    purple = "bb9af7";
    red = "f7768e";
    white = "c0caf5";
    yellow = "e0af68";
  };

  base00 = "1a1b26";
  base01 = "414868";
  base02 = "565f89";
  base03 = "9aa5ce";
  base04 = "a9b1d6";
  base05 = "c0caf5";
  base06 = "c0caf5";
  base07 = "006a83";
  base08 = "f7768e";
  base09 = "e0af68";
  base0A = "7dcfff";
  base0B = "73daca";
  base0C = "7aa2f7";
  base0D = "bb9af7";
  base0E = "e0af68";
  base0F = "006a83";

  accent = "bb9af7";

  wallpaper = "./wallpapers/luciferin.png";

  cursor = {
    hypr = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-hyprcursors";
    };

    x = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
    };
  };

  helix = "tokyonight";

  gtk = {
    enable = true;
    packages = pkgs.tokyonight-gtk-theme.override {
      colorVariant = [ "dark" ];
      sizeVariant = [ "compact" ];
      iconVariant = [ "Dark" ];
    };
    name = "Tokyonight-Dark";
  };
}