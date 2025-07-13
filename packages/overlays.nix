lib:
let
  inherit (builtins)
    mapAttrs
    readDir
    ;

  sources = import ../npins;

  overlayPatches = final: prev: {
    
  };

  overlayAuto =
    final: prev:
    (
      readDir ./.
      |> lib.filterAttrs (_: value: value == "directory")
      |> mapAttrs (
        name: _:
        final.callPackage ./${name} {
          
        }
      )
    ) // { };

  overlayAdditionalSources = final: prev: {
    # Switching lix over to the direct build
    # lix =
    #   let
    #     lixModule = import "${sources.nixosModule}/module.nix";
    #     lixSrc = import sources.lix;
    #   in final lixModule { lix = lixSrc; };

    # nix = prev.nix;
    # lix = prev.lix;

    maid = (import sources.nix-maid) final ../modules/maid;

    zen-browser = ((import sources.zen-browser-flake) { pkgs = final; }).zen-browser;
  };

  # overlayWrapperManager =
  #   final: prev:
  #   let
  #     wrapper-manager = import sources.wrapper-manager;
  #     evald = wrapper-manager.lib {
  #       pkgs = prev;
  #       modules =
  #         builtins.readDir ../modules/wrapper-manager
  #         |> builtins.attrNames
  #         |> map (n: ../modules/wrapper-manager/${n});
  #     };
  #     in
  #     mapAttrs (_: value: value.wrapped) evald.config.wrappers;

    # overlayVersion = final: prev: {
    #   lib = prev.lib.extend (
    #     finalLib: prevLib: {
    #       trivial = prevLib.trivial // {
    #         versionSuffix = ".${finalLib.substring 0 7 sources.nixpkgs.revision}";
    #       };
    #     }
    #   );
    # };
in
lib.composeManyExtensions [
  overlayPatches
  overlayAuto
  overlayAdditionalSources
  # overlayWrapperManager
  # overlayVersion
]
