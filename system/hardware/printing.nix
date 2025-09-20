{ pkgs, ... }:
{
  services = {
    printing = {
      enable = true;

      drivers = builtins.attrValues {
        inherit (pkgs) 
          gutenprint
          hplip 
          brlaser
          ;
      };
    };

    # required for network discovery of printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
