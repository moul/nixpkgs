{ config, pkgs, lib, ... }:

{
  home = {
    packages = [
      pkgs.curl
      pkgs.docker
      pkgs.fortune
      pkgs.git
      pkgs.htop
      pkgs.hub
      pkgs.mosh
      pkgs.tmux
      pkgs.wget
    ];
    #username = "moul";
    #homeDirectory = "/home/moul";
  };

  programs = {
    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    git = {
      enable = true;
      userName = "Manfred Touron";
      userEmail = "94029+moul@users.noreply.github.com";
    };

    home-manager = {
      enable = true;
      path = "…";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };
}
