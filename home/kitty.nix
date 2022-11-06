{ config, lib, pkgs, ... }:

{
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  programs.kitty.settings = {
    font_family = "Iosevka Nerd Font";
    font_size = "12.0";
    adjust_line_height = "100%";
    adjust_column_width = "100%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";
    window_padding_width = "5 5 1 5";

    # Tab bar
    tab_bar_edge = "bottom";
    tab_bar_style = "powerline";
    tab_bar_min_tabs = "2";
    #tab_title_template = "Tab {index}: {title}";
    tab_title_template = "{title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "#";
  };

  # Change the style of italic font variants
  programs.kitty.extraConfig = ''
    font_features                      PragmataProMonoLiga-Italic +ss06
    font_features                      PragmataProMonoLiga-BoldItalic +ss07
    clear_all_shortcuts                yes
    rectangle_select_modifiers         no_op
    kitty_mod                          cmd

    map kitty_mod+c                    copy_to_clipboard
    map kitty_mod+v                    paste_from_clipboard
    map kitty_mod+u                    input_unicode_character
    map kitty_mod+enter                toggle_fullscreen
    map kitty_mod+f                    show_scrollback

    map kitty_mod+0                    change_font_size all 0
    map kitty_mod+shift+equals         change_font_size all +1.0
    map kitty_mod+shift+minus          change_font_size all -1.0

    map kitty_mod+0x1d                 change_font_size all 0
    map kitty_mod+0x18                 change_font_size all +1.0
    map kitty_mod+0x1b                 change_font_size all -1.0

    map kitty_mod+shift+u              kitten unicode_input
    map kitty_mod+.                    reload_config_file

    map kitty_mod+t                    new_tab
    map kitty_mod+w                    close_tab
    map kitty_mod+left                 prev_tab
    map kitty_mod+right                next_tab
  '';

  programs.kitty.extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";
  # }}}

  # Colors config ------------------------------------------------------------------------------ {{{
  programs.kitty.extras.colors = {
    enable = true;

    # Background dependent colors
    dark =  config.colors.ManfredTouron-dark.pkgThemes.kitty;
    light = config.colors.ManfredTouron-dark.pkgThemes.kitty;
    #light = config.colors.ManfredTouron-light.pkgThemes.kitty;
  };

  programs.fish.functions.set-term-colors = {
    body = "term-background $term_background";
    onVariable = "term_background";
  };
  programs.fish.interactiveShellInit = ''
    # Set term colors based on value of `$term_backdround` when shell starts up.
    set-term-colors
  '';
  # }}}
}
