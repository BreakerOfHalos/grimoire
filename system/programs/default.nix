{ config, ... }:
{
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

    # Password manager is critical
    _1password.enable = true;

    # 1Password, ofc
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "breakerofhalos" ];
    };

    # Directory environments
    direnv.enable = true;

    # Maybe my shell
    fish.enable = true;

    # tui file manager
    yazi.enable = true;

    # Pretty prompt
    starship.enable = true;
  };
}
