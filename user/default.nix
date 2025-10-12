rec
{
  theme = import ./theme;

  packages = pkgs:
  let
    theme = import ./theme pkgs;
  in
  {};

  shell = pkgs:
    pkgs.mkShell {
      name = "breaker-devShell";
      shellHook = ''
        fish
      '';
      buildInputs = builtins.attrValues {
        inherit
          (pkgs)
          fish
          helix
          nixos-facter
          ;
      };
    };

  module = { pkgs, ... }: {
    config = {
      environment.systemPackages = builtins.attrValues (packages pkgs);
      
      programs = {
        fish.enable = true;
        # disable command-not-found, it doesn't help, and it adds perl
        # which we don't need, and we know when we don't have a command anyway
        command-not-found.enable = false;

        # like `thefuck`, but in rust and actually maintained
        pay-respects.enable = true;

        # pager
        less = {
          enable = true;
          lessopen = null; # don't install perl thanks
        };

        # Directory environments
        direnv = {
          enable = true;
          enableFishIntegration = true;
          nix-direnv = {
            enable = true;
            package = pkgs.lorri;
          };
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        # Pretty prompt
        starship.enable = true;

        # Password management
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ "breakerofhalos" ];
        };

        # Gayming
        steam = {
          enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin.steamcompattool ];
          gamescopeSession.enable = false;
        };

        gamescope = {
          enable = true;
          capSysNice = true;
        };
      };
    };

    imports = [
      ./packages.nix
      ./git.nix
      ./gtk
    ];
  };
}
