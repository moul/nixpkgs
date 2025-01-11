{ config, lib, pkgs, ...}:

let
  my-emacs = pkgs.emacs30-nox.override {
    #withNativeCompilation = true;
    #withSQLite3 = true;
    #withTreeSitter = true;
    #withWebP = true;
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

    extraPackages = epkgs: let
      #sops = epkgs.trivialBuild {
      #  pname = "sops";
      #  version = "0.1.4";
      #  src = pkgs.fetchurl {
      #    url = "https://raw.githubusercontent.com/djgoku/sops/v0.1.4/sops.el";
      #    hash = "sha256-GmEexfdDLQfgUQ2WrVo/C9edF9/NuocO3Dpnv3F7/qA=";
      #  };
      #};
    in
      with epkgs; [
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

  home.file.".emacs.d/init.el" = {
    source = ../config/emacs/init.el;
  };
  home.file.".emacs.d/config.org" = {
    source = ../config/emacs/config.org;
  };

  # setup alias
  programs.zsh.shellAliases.emacs = "em";
  programs.zsh.shellAliases.emasc = "em";
  programs.zsh.shellAliases.eamsc = "em";
  programs.zsh.shellAliases.emaccs = "em";
  programs.zsh.shellAliases.emacss = "em";
  programs.zsh.shellAliases.raw-emacs = "${my-emacs}/bin/emacs";
}


# inspirations
# - https://github.com/philandstuff/nixcfg/blob/4d2a846335d4b7619f644a04005b10eb59536cd9/home-manager/emacs.nix#L39

#{ config, lib, pkgs, ... }:
#
#let
#  my-emacs = pkgs.emacs30-nox.override {
#    withNativeCompilation = true;
#    withSQLite3 = true;
#    withTreeSitter = true;
#    withWebP = true;
#  };
#  my-emacs-with-packages = (pkgs.emacsPackagesFor my-emacs).emacsWithPackages (epkgs: with epkgs; [
#    #pkgs.mu
#    #vterm
#    #multi-vterm
#    #pdf-tools
#    #treesit-grammars.with-all-grammars
#    go-mode
#    markdown-mode
#  ]);
#  #em = pkgs.writeScriptBin "em"
#  #  (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacs}" ]
#  #    (lib.readFile ./../config/em));
#  #raw-emacs = pkgs.writeScriptBin "raw-emacs"
#  #  (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacs}" ]
#  #    (lib.readFile ./../config/raw-emacs));
#  em = pkgs.writeScriptBin "em"
#    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs-with-packages}" ]
#      (lib.readFile ./../config/em));
#  raw-emacs = pkgs.writeScriptBin "raw-emacs"
#    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs-with-packages}" ]
#      (lib.readFile ./../config/raw-emacs));
#
#in
#{
#  programs.emacs = {
#    enable = true;
#    package = my-emacs-with-packages;
#        extraConfig = ''
#      (define-derived-mode gno-mode go-mode "GNO"
#        "Major mode for GNO files, an alias for go-mode."
#        (setq-local tab-width 8))
#      (define-derived-mode gno-dot-mod-mode go-dot-mod-mode "GNO Mod"
#        "Major mode for GNO mod files, an alias for go-dot-mod-mode.")
#    '';
#
#  };
#
#  home.packages = with pkgs; [
#    sqlite # required by magit
#    emacs-all-the-icons-fonts
#    #(aspellWithDicts (d: [d.en d.fr]))
#    #ghostscript
#    #tetex
#    #poppler
#    #mu
#    #wordnet
#    
#    em
#    raw-emacs
#  ];
#
#
#
#
#
#  ## home dot D
#  # spacemacs
#  home.file."emacs/spacemacs" = {
#    source = pkgs.spacemacs;
#    recursive = true;
#  };
#
#  # home.file."emacs/doom" = {
#  #  source = pkgs.doomemacs;
#  #  recursive = true;
#  # };
#
#  home.file.".emacs.d" = {
#    source = pkgs.chemacs2;
#    recursive = true;
#  };
#
#  home.file.".emacs-profile" = with pkgs; {
#    source = writeText "emacs-profiles" "spacemacs";
#  };
#  home.file.".emacs-profiles.el" = with pkgs; {
#    source = writeText "emacs-profiles" ''
#      (
#       ("doom" . ((user-emacs-directory . "~/emacs/doomemacs")
#             (env . (("DOOMDIR" . "~/doom-config")))))
#       ("spacemacs" . ((user-emacs-directory . "~/emacs/spacemacs")))
#      )
#    '';
#  };
#
#
#  # spacemacs
#  home.file.".spacemacs.d" = {
#    source = "${lib.cleanSource ../config/spacemacs}";
#    recursive = true;
#  };
#
##  programs.emacs.enable = true;
##  #programs.emacs.package = pkgs.emacs-gtk;
##  programs.emacs.package = pkgs.emacs-mac;
##
#  # setup alias
#  #programs.zsh.shellAliases.emacs = "${xterm-emacs}/bin/xemacs";
#  programs.zsh.shellAliases.emacs = "em";
#  programs.zsh.shellAliases.emasc = "em";
#  programs.zsh.shellAliases.eamsc = "em";
#  programs.zsh.shellAliases.emaccs = "em";
#  programs.zsh.shellAliases.emacss = "em";
##  programs.zsh.shellAliases.emacsclient =
##    "${xterm-emacsclient}/bin/xemacsclient";
##  programs.zsh.shellAliases.ec = "${xterm-emacsclient}/bin/xemacsclient -nw";
#
#
#}
#
#
#
#
#
##{ config, lib, pkgs, ... }:
##let
##  inherit (config.home) user-info homeDirectory;
##  xterm-emacsclient = pkgs.writeShellScriptBin "xemacsclient" ''
##    export TERM=xterm-emacs
##    ${pkgs.emacs-gtk}/bin/emacsclient $@
##  '';
##  xterm-emacs = pkgs.writeShellScriptBin "xemacs" ''
##    export TERM=xterm-emacs
##    ${pkgs.emacs-gtk}/bin/emacs $@
##  '';
##in {
##
##}

