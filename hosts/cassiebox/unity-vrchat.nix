{ ... }:

# https://gist.github.com/nil-vr/09f6ebf470701d007553cf0de7c2c3ee?permalink_comment_id=6196632#gistcomment-6196632
{
  home-manager.users.cassie = { pkgs, config, lib, ... }: let
    unityhub = pkgs.unityhub.override { extraPkgs = p: [ p.ipafont ]; };
    editorDir = "${config.home.homeDirectory}/Unity/Hub/Editor/2022.3.22f1/Editor";
  
    wrapper = pkgs.writeShellScript "unity-fhs" ''
      real="${editorDir}/Unity.real"
      exec -a "$real" "${unityhub.fhsEnv}/bin/unityhub-fhs-env" "$real" "$@"
    '';
  in {
    home.packages = [ unityhub pkgs.alcom ];
    home.activation.wrapUnityFhs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      editor="${editorDir}"
      if [ -e "$editor/Unity" ] && [ ! -e "$editor/Unity.real" ]; then
        $DRY_RUN_CMD mv "$editor/Unity" "$editor/Unity.real"
      fi
      if [ -e "$editor/Unity.real" ]; then
        $DRY_RUN_CMD install -m755 ${wrapper} "$editor/Unity"
      fi
    '';
  };
}