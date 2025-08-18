{
  theme = import ./theme;

  shell = pkgs.fish; 

  module = { pkgs, ... }: {
    config = {
      programs = {
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
      };
    };

    imports = [
      ./packages.nix
      ./git
      ./gtk
    ];
  };
}