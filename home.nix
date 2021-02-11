{ config, pkgs, lib, ... }:

{
  home.packages = [
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

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  programs.git = {
    enable = true;
    userName = "Manfred Touron";
    userEmail = "94029+moul@users.noreply.github.com";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  #home.username = "moul";
  #home.homeDirectory = "/home/moul";
}
