{
  config,
  lib,
  pkgs,
  ...
}: 
{
  options = {
    homix = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        options,
        ...
      }: {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            description = ''
              Path to the file relative to the $HOME directory.
              If not defined, name of attribute set will be used.
            '';
          };
          source = lib.mkOption {
            type = lib.types.path;
            description = "Path of the source file or directory.";
          };
          text = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.lines;
            description = "Text of the file.";
          };
        };
        config = {
          path = lib.mkDefault name;
          source = lib.mkIf (config.text != null) (
            let
              name' = "homix-" + lib.replaceStrings ["/"] ["-"] name;
            in
              lib.mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }));
    };
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.homix = lib.mkEnableOption "Enable homix for selected user";
      });
    };
  };

  config = 
    let
      # list of users managed by homix
      users = builtins.attrNames (lib.filterAttrs (name: user: user.homix) config.users.users);

      homix-link = 
        let
          files = builtins.map (f: ''
            FILE=$HOME/${f.path}
            mkdir -p $(dirname $FILE)
            ln -sf ${f.source} $FILE
          '') (lib.attrValues config.homix);
        in
          pkgs.writeShellScript "homix-link" ''
            #!/bin/sh
            ${builtins.concatStringsSep "\n" files}
          '';

      mkService = user: {
        name = "homix-${user}";
        value = {
          wantedBy = ["multi-user.target"];
          description = "Setup homix environment for ${user}.";
          serviceConfig = {
            Type = "oneshot";
            User = "${user}";
            ExecStart = "${homix-link}";
          };
          environment = {
            # epic systemd momento
            HOME = config.users.users.${user}.home;
          };
        };
      };

      services = builtins.listToAttrs (builtins.map mkService users);
    in 
  {
    systemd.services = services;
  };
}