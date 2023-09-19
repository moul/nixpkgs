{ config, lib, pkgs, ... }:

let
  xterm-emacsclient = pkgs.writeShellScriptBin "xemacs" ''
    export TERM=xterm-emacs
    ${pkgs.emacs-gtk}/bin/emacsclient $@
  '';

  stdin-emacsclient = pkgs.writeShellScriptBin "semacs" ''
    TMP="$(mktemp /tmp/stdin-XXXX)"
    cat > $TMP.ansi
    ${xterm-emacsclient}/bin/xemacs -t $TMP.ansi
    rm $TMP*
  '';

  magit-emacsclient = pkgs.writeShellScriptBin "magit" ''
    ${xterm-emacsclient}/bin/xemacs -t -e '(magit-status) (delete-other-windows)'
  '';

  scratch-emacsclient = pkgs.writeShellScriptBin "scratch" ''
    ${xterm-emacsclient}/bin/xemacs -t -e '(spacemacs/switch-to-scratch-buffer) (delete-other-windows) (evil-emacs-state)'
  '';

  theme = config.colors.catppuccin-macchiato;
in {
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty.enable = true;

  programs.kitty.settings = {
    # https://fsd.it/shop/fonts/pragmatapro/
    font_family = "FiraCode Nerd Font Mono";
    font_size = "14.0";
    adjust_line_height = "120%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";
    window_padding_width = "5";
    window_border_width = "1pt";

    scrollback_pager_history_size = 100;
    macos_option_as_alt = "yes";
    startup_session = "default-session.conf";

    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_title_template = "{index}: {title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";

    enabled_layouts = "horizontal,grid,splits,vertical";
    enable_audio_bell = "no";
    bell_on_tab = "yes";

    background_opacity = "0.85";

    kitty_mod = "ctrl+alt";

    font_features =
      "+cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum";
  };

  # # Change the style of italic font variants
  # programs.kitty.extraConfig = ''
  #   font_features FiraCode Nerd Font
  # '';

  programs.kitty.extras.useSymbolsFromNerdFont = "FiraCode Nerd Font Mono";
  # }}}

  programs.kitty.extras.colors = {
    enable = true;

    # Background dependent colors
    dark = theme.pkgThemes.kitty;
    # light = config.colors.solarized-light.pkgThemes.kitty;
  };

  programs.truecolor.enable = true;
  programs.truecolor.useterm = "xterm-kitty";
  programs.truecolor.terminfo = "${pkgs.kitty.terminfo}/share/terminfo";

  programs.kitty.keybindings = {
    # open new tab with cmd+t
    "cmd+t" = "new_tab_with_cwd";

    # open new split (window) with cmd+d retaining the cwd
    "kitty_mod+l" = "next_layout";

    "cmd+d" = "launch --cwd=current --location=vsplit";
    "cmd+shift+d" = "launch --cwd=current --location=hsplit";

    "cmd+enter" = "new_os_window_with_cwd";

    "shift+cmd+up" = "move_window up";
    "shift+cmd+left" = "move_window left";
    "shift+cmd+right" = "move_window right";
    "shift+cmd+down" = "move_window down";

    "kitty_mod+left" = "neighboring_window left";
    "kitty_mod+right" = "neighboring_window right";
    "kitty_mod+up" = "neighboring_window up";
    "kitty_mod+down" = "neighboring_window down";

    # clear the terminal screen
    "cmd+k" =
      "combine : clear_terminal scrollback active : send_text normal,application x0c";

    # Map cmd + <num> to corresponding tabs
    "cmd+1" = "goto_tab 1";
    "cmd+2" = "goto_tab 2";
    "cmd+3" = "goto_tab 3";
    "cmd+4" = "goto_tab 4";
    "cmd+5" = "goto_tab 5";
    "cmd+6" = "goto_tab 6";
    "cmd+7" = "goto_tab 7";
    "cmd+8" = "goto_tab 8";
    "cmd+9" = "goto_tab 9";

    # changing font sizes
    "kitty_mod+equal" = "change_font_size all +1.0";
    "kitty_mod+minus" = "change_font_size all -1.0";
    "kitty_mod+0" = "change_font_size all 0";

    # hints
    "cmd+g" =
      "kitten hints --type=linenum --linenum-action=self ${xterm-emacsclient}/bin/xemacs -t +{line} {path}";
    # screen rollback
    "cmd+f" =
      "launch --cwd=current --type=overlay --stdin-source=@screen_scrollback --stdin-add-formatting ${stdin-emacsclient}/bin/semacs";
    # editor
    "kitty_mod+s" =
      "launch --cwd=current --type=overlay ${scratch-emacsclient}/bin/scratch";
    "kitty_mod+o" =
      "launch --cwd=current --type=overlay ${xterm-emacsclient}/bin/xemacs -t .";
    "kitty_mod+d" =
      "launch --cwd=current --type=overlay  ${pkgs.lazydocker}/bin/lazydocker";
    "kitty_mod+g" =
      "launch --cwd=current --type=overlay  ${pkgs.lazygit}/bin/lazygit";
  };
}
