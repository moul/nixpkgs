{ config, pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.lfs.enable = true;

  programs.git.extraConfig = {
    # core.editor = "${pkgs.emacs-nox}/bin/emacs --remote-wait-silent -cc split";
    diff.colorMoved = "default";
    pull.rebase = true;
    init.defaultBranch = "main";
  } // (if pkgs.stdenv.isDarwin then {
    gpg.format = "ssh";
    user.signingKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID+r9TcD4g/DVW5/9W9grjD700PJccMonLEWnB+v++42";
    gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    commit.gpgsign = true;
  } else
    { });

  programs.git.ignores = [ ".DS_Store" ];

  programs.git.userEmail = config.home.user-info.email;
  programs.git.userName = config.home.user-info.fullName;

  # Enhanced diffs
  programs.git.delta.enable = true;

  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
