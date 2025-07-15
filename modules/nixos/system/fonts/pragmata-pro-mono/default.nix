{ lib
, stdenvNoCC
, requireFile
, variant ? "no-ligatures"
, ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pragmata-pro-mono";
  version = "0.9";

  src = requireFile rec {
    name = "${finalAttrs.pname}-${variant}-${finalAttrs.version}";
    sha256 = "0q6aai0s3g9qxr6sw7yhmd5na41wfy3bh0lysiv3v6i37dif1qh1";
    message = ''
      This file has to be downloaded from the designer's site
      (https://fsd.it/my-account/downloads/). Following that,
      separate out the modularspace and monospace fonts and
      only select the non-ligature versions.

      Name the folder to match "${finalAttrs.pname}", then run:

      mv \$PWD/pragmata-pro-mono \$PWD/${name}
      nix-prefetch-url --type sha256 file://\$PWD/${name}
    '';
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype *.otf
    install -D -m444 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  ''; 

  meta = {
    description = "Pragmata Pro Mono Typeface";
    longDescription = "...";
    homepage = "https://fsd.it/shop/fonts/pragmatapro/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
})
