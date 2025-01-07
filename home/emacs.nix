{ config, lib, pkgs, ... }:

let
  my-emacs = pkgs.emacs30-nox.override {
    withNativeCompilation = true;
    withSQLite3 = true;
    withTreeSitter = true;
    withWebP = true;
  };
  my-emacs-with-packages = (pkgs.emacsPackagesFor my-emacs).emacsWithPackages (epkgs: with epkgs; [
    #pkgs.mu
    #vterm
    #multi-vterm
    #pdf-tools
    #treesit-grammars.with-all-grammars
    go-mode
  ]);
  #em = pkgs.writeScriptBin "em"
  #  (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacs}" ]
  #    (lib.readFile ./../config/em));
  #raw-emacs = pkgs.writeScriptBin "raw-emacs"
  #  (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${pkgs.emacs}" ]
  #    (lib.readFile ./../config/raw-emacs));
  em = pkgs.writeScriptBin "em"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs-with-packages}" ]
      (lib.readFile ./../config/em));
  raw-emacs = pkgs.writeScriptBin "raw-emacs"
    (builtins.replaceStrings [ "\${pkgs.emacs}" ] [ "${my-emacs-with-packages}" ]
      (lib.readFile ./../config/raw-emacs));

in
{
  programs.emacs = {
    enable = true;
    package = my-emacs-with-packages;
  };

  home.packages = with pkgs; [
    sqlite # required by magit
    emacs-all-the-icons-fonts
    #(aspellWithDicts (d: [d.en d.fr]))
    #ghostscript
    #tetex
    #poppler
    #mu
    #wordnet
    
    em
    raw-emacs
  ];





  ## home dot D
  # spacemacs
  home.file."emacs/spacemacs" = {
    source = pkgs.spacemacs;
    recursive = true;
  };

  # home.file."emacs/doom" = {
  #  source = pkgs.doomemacs;
  #  recursive = true;
  # };

  home.file.".emacs.d" = {
    source = pkgs.chemacs2;
    recursive = true;
  };

  home.file.".emacs-profile" = with pkgs; {
    source = writeText "emacs-profiles" "spacemacs";
  };
  home.file.".emacs-profiles.el" = with pkgs; {
    source = writeText "emacs-profiles" ''
      (
       ("doom" . ((user-emacs-directory . "~/emacs/doomemacs")
             (env . (("DOOMDIR" . "~/doom-config")))))
       ("spacemacs" . ((user-emacs-directory . "~/emacs/spacemacs")))
      )
    '';
  };


  # spacemacs
  home.file.".spacemacs.d" = {
    source = "${lib.cleanSource ../config/spacemacs}";
    recursive = true;
  };

#  programs.emacs.enable = true;
#  #programs.emacs.package = pkgs.emacs-gtk;
#  programs.emacs.package = pkgs.emacs-mac;
#
  # setup alias
  #programs.zsh.shellAliases.emacs = "${xterm-emacs}/bin/xemacs";
  programs.zsh.shellAliases.emacs = "em";
  programs.zsh.shellAliases.emasc = "em";
  programs.zsh.shellAliases.eamsc = "em";
  programs.zsh.shellAliases.emaccs = "em";
  programs.zsh.shellAliases.emacss = "em";
#  programs.zsh.shellAliases.emacsclient =
#    "${xterm-emacsclient}/bin/xemacsclient";
#  programs.zsh.shellAliases.ec = "${xterm-emacsclient}/bin/xemacsclient -nw";


}





#{ config, lib, pkgs, ... }:
#let
#  inherit (config.home) user-info homeDirectory;
#  xterm-emacsclient = pkgs.writeShellScriptBin "xemacsclient" ''
#    export TERM=xterm-emacs
#    ${pkgs.emacs-gtk}/bin/emacsclient $@
#  '';
#  xterm-emacs = pkgs.writeShellScriptBin "xemacs" ''
#    export TERM=xterm-emacs
#    ${pkgs.emacs-gtk}/bin/emacs $@
#  '';
#in {
#
#}

