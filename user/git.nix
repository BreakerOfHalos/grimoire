{
  pkgs,
  lib,
  ...
}: 
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user = {
        email = "thin.road5750@fastmail.com";
        name = "breakerofhalos";
        signingkey = "~/.ssh/id_ed25519_sk_git_signing.pub";
      };
      
      init = {
        defaultBranch = "main";
      };
      
      core = {
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        editor = "hx";
      };

      pull = {
        rebase = true;
        ff = "only";
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      rerere = {
        autoupdate = true;
        enabled = true;
      };

      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

      branch.autosetupmerge = "true";
      push.default = "current";
      merge.stat = "true";
      repack.usedeltabaseoffset = "true";
    };
  };
}
