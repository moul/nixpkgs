{ pkgs, config, ... }:

let
  asdf-config = pkgs.writeText "asdfrc" ''
    # See the docs for explanations: https://asdf-vm.com/manage/configuration.html

    legacy_version_file = no
    use_release_candidates = no
    always_keep_download = no
    disable_plugin_short_name_repository = no
    ${if pkgs.stdenv.isDarwin then
      "java_macos_integration_enable = yes"
    else
      ""}
  '';

in {
  home.file."${config.xdg.configHome}/asdf/asdfrc" = { source = asdf-config; };
  # # asdf env variables
  home.sessionVariables = {
    ASDF_CONFIG_FILE = "${config.xdg.configHome}/asdf/asdfrc";
    ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
    ASDF_DIR = "${pkgs.asdf-vm}/share/asdf-vm";
  };
}
