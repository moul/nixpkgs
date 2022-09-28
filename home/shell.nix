{ config, lib, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "em";
    VISUAL = "em";
    GIT_EDITOR = "em";
  };
}
