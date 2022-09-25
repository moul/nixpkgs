{ config, pkgs, lib, ... }:

let
  home_dir = "${config.home.homeDirectory}";
  profile_dir = "${config.home.profileDirectory}";
in {
  # Install and setup ZSH
  programs.zsh = {
    enable = true;
    profileExtra = ''
      if [ -f "${profile_dir}/etc/profile.d/nix.sh" ]; then
         source "${profile_dir}/etc/profile.d/nix.sh"
      fi
    '';
  };

  # install emacs service
  services.emacs = {
    package = pkgs.emacsGcc;
    enable = true;
  };

  # setup ssh agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
