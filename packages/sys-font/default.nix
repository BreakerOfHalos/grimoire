{ lib
, stdenvNoCC
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sys";
  version = "1.1";

  src = requireFile rec {
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    sha256 = "1h9i2vkrbjirxqac6qkj7l85axknycl4xjxd3nwc9fibrjk5m3pw";
    message = ''
      This file has to be downloaded from the designer's site
      (https://fsd.it/my-account/downloads/). Following that,
      separate out the modularspace and monospace fonts and
      only select the non-ligature versions.

      Name the folder to match "${pname}", then run:

      mv \$PWD/sys \$PWD/${name}
      nix-prefetch-url --type sha256 file://\$PWD/${name}
    '';
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype *.otf
    install -D -m444 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  ''; 
};

  meta = {
    description = "Sys Typeface";
    longDescription = "...";
    homepage = "https://fsd.it/shop/fonts/pragmatapro/";
    license = lib.license.unfree;
    platforms = lib.platforms.all;
  };
})
