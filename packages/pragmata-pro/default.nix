{ lib
, stdenvNoCC
, variant ? "no-ligatures"
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pragmata-pro";
  version = "0.9";

  src = requireFile rec {
    name = "${finalAttrs.pname}-${variant}-${finalAttrs.version}";
    sha256 = "015fb7bpglfn69a465531049j9c0sawyxjqns4a4had0bn82x4gi";
    message = ''
      This file has to be downloaded from the designer's site
      (https://fsd.it/my-account/downloads/). Following that,
      separate out the modularspace and monospace fonts and
      only select the non-ligature versions.

      Name the folder to match "${pname}", then run:

      mv \$PWD/pragmata-pro \$PWD/${name}
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
    description = "Pragmata Pro Typeface";
    longDescription = "...";
    homepage = "https://fsd.it/shop/fonts/pragmatapro/";
    license = lib.license.unfree;
    platforms = lib.platforms.all;
  };
})
