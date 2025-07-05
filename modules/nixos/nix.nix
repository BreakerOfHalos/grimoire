{ config
, lib
, options
, ... }: {
  nix = {
    # Killing channels per https://jade.fyi/blog/pinning-nixos-with-npins/
    channel.enable = false;

    # Automatic garbage collection, of course.
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    settings = {
      # Freeing up space if we run low. It'll free up to 20GB whenever there's less
      # than 5GB left. It's in bytes, so multiply by 1024 three times.
      min-free =  5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      auto-optimise-store = true;

      # users or groups that are allowed to do anything with the Nix daemo
      allowed-users = [ "@wheel" ];
      # users or groups that are allowed to manage the Nix store
      trusted-users = [ "@wheel" ];

      # let the system decide how many jobs to run
      max-jobs = "auto";

      # build inside sandboxed environments
      sandbox = true;

      system-features = [
        "nixos-test"
        "kvm"
        "recursive-nix"
        "big-parallel"
      ];

      # keeps things going while builds happen if there's a failure
      keep-going = true;

      log-lines = 30;

      experimental-features = [
        # This config isn't using flakes, but still uses them for the new commands and tools.
        "flakes"

        # The new CLI, which is required.
        "nix-command"

        # I want the shiny lix toys, even if I'm not quite sure what they do.
        "lix-custom-sub-commands"

        # IDK seems neat and less annoying than having temp user ghosts.
        "auto-allocate-uids"

        # This lets us use cgroups for builds, as long as `use-cgroups.enable = true;` is set
        "cgroups"

        # Laying pipe
        "pipe-operator"
      ];

      # Adds more connections for imports and caches.
      http-connections = 50;

      # Get behind me Jesus.
      accept-flake-config = false;

      # Actually setting the feature to be on.
      use-cgroups = true;

      # Using XDG base directories seems to make sense.
      use-xdg-base-directories = true;
    };
  };
}
