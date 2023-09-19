{ config, pkgs, ... }:

{
  # Git
  programs.git = {
    # https://rycee.gitlab.io/home-manager/options.html#opt-enable
    # Aliases config in ./configs/git-aliases.nix
    enable = true;
    userEmail = config.home.user-info.email;
    userName = config.home.user-info.username;

    extraConfig = {
      core.editor = "em";
      core.whitespace = "trailing-space,space-before-tab";
      diff.colorMoved = "default";
      pull.rebase = true;
    };

    ignores = [ "*~" "*.swp" "*#" ".#*" ".DS_Store" ];

    # Enhanced diffs
    delta.enable = true;

    # large file
    lfs.enable = true;

    aliases = {
      lg =
        "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
    };
  };

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
