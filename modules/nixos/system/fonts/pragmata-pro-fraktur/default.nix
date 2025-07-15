{ lib
, requireFile
, stdenvNoCC
, ... 
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pragmata-pro-fraktur";
  version = "1.2";

  src = requireFile rec {
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    sha256 = "06mv8r6z0ky7jkapwjia897kv0wmb9f6930706kam24rij3wiqz5";
    message = ''
      This file has to be downloaded from the designer's site
      (https://fsd.it/my-account/downloads/). Following that,
      separate out the modularspace and monospace fonts and
      only select the non-ligature versions.

      Name the folder to match "${finalAttrs.pname}", then run:

      mv \$PWD/pragmata-pro-fraktur \$PWD/${name}
      nix-prefetch-url --type sha256 file://\$PWD/${name}
    '';
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  ''; 

  meta = {
    description = "Pragmata Pro Fraktur Typeface";
    longDescription = "...";
    homepage = "https://fsd.it/shop/fonts/pragmatapro/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
})
