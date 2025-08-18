{ ... }: 
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user = {
        email = "me@breakerofhalos.monster";
        name = "breakerofhalos";
        signingKey = "056CFD15A9F99B0E";
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

      branch.autosetupmerge = "true";
      push.default = "current";
      merge.stat = "true";
      repack.usedeltabaseoffset = "true";
    };
  };
}