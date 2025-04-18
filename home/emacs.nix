{ config, lib, pkgs, ... }:

let
  my-emacs = pkgs.emacs30-nox.override {
    withNativeCompilation = false;
    noGui = true;
  };
  em = pkgs.writeScriptBin "em"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs}" ]
      (lib.readFile ./../config/em));
  raw-emacs-old = pkgs.writeScriptBin "raw-emacs-old"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs}" ]
      (lib.readFile ./../config/raw-emacs));
in {
  programs.emacs = {
    enable = true;
    package = my-emacs;

    extraConfig = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
      ; macOS ls doesn't support --dired
      (setq dired-use-ls-dired nil)
    '';

    extraPackages = epkgs:
      let
        #sops = epkgs.trivialBuild {
        #  pname = "sops";
        #  version = "0.1.4";
        #  src = pkgs.fetchurl {
        #    url = "https://raw.githubusercontent.com/djgoku/sops/v0.1.4/sops.el";
        #    hash = "sha256-GmEexfdDLQfgUQ2WrVo/C9edF9/NuocO3Dpnv3F7/qA=";
        #  };
        #};
      in with epkgs; [
        org

        better-defaults
        diminish
        epkgs."ido-completing-read+"
        smex

        # epkgs.exec-path-from-shell

        flycheck

        envrc

        company
        dockerfile-mode
        go-mode
        kubel
        lsp-mode
        lsp-pyright
        lsp-ui
        magit
        markdown-mode
        nix-mode
        nix-sandbox
        pretty-mode
        projectile
        #rust-mode
        #sops
        #terraform-mode
        yaml-mode
        polymode
      ];
  };

  home.packages = with pkgs; [
    sqlite # required by magit
    em
    raw-emacs-old
  ];

  home.file.".emacs.d/init.el" = { source = ../config/emacs/init.el; };
  home.file.".emacs.d/config.org" = { source = ../config/emacs/config.org; };

  # setup alias
  programs.zsh.shellAliases.emacs = "em";
  programs.zsh.shellAliases.emasc = "em";
  programs.zsh.shellAliases.eamsc = "em";
  programs.zsh.shellAliases.emaccs = "em";
  programs.zsh.shellAliases.emacss = "em";
  programs.zsh.shellAliases.raw-emacs = "${my-emacs}/bin/emacs";
}
