{
  security.pam = {
    # fix "too many files open" errors while writing a lot of data at once
    # was previously a huge issue when rebuilding
    loginLimits = [
      {
        domain = "@wheel";
        item = "nofile";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@wheel";
        item = "nofile";
        type = "hard";
        value = "1048576";
      }
    ];

    # allow screen lockers to also unlock the screen
    # (e.g. hyprlock)
    services = {
      hyprlock.text = "auth include login";

      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      greetd = {
        enableGnomeKeyring =true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      tuigreet = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };
    };
  };
}
