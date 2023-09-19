{ config, lib, pkgs, ... }:

let
  inherit (config.home) user-info homeDirectory;
  configDir = ".config";
  cacheDir = ".cache";
  dataDir = ".local/share";
  oh-my-zsh-custom = "${configDir}/oh-my-zsh";

  xterm-emacsclient = pkgs.writeShellScriptBin "xemacsclient" ''
    export TERM=xterm-emacs
    ${pkgs.emacs-gtk}/bin/emacsclient $@
  '';
  xterm-emacs = pkgs.writeShellScriptBin "xemacs" ''
    export TERM=xterm-emacs
    ${pkgs.emacs-gtk}/bin/emacs $@
  '';

  restart-service = pkgs.writeShellScriptBin "restart-service" ''
    set -e

    plist_name="$1"
    plist_path=$(find $HOME/Library/LaunchAgents -name "$plist_name" 2>/dev/null | head -n 1)

    if [[ -z "$plist_path" ]]; then
        echo "Unable to find $plist_name"
        exit 1
    fi

    echo "restarting $plist_name"

    major_version=$(sw_vers -productVersion | cut -d. -f2)

    if [[ $major_version -ge 16 ]]; then
        # For macOS Big Sur and later
        launchctl bootout system "$plist_path" && launchctl bootstrap system "$plist_path"
    else
        # For macOS Catalina and earlier
        launchctl unload "$plist_path" && launchctl load "$plist_path"
    fi
  '';

in {
  xdg = {
    enable = true;
    configHome = "${homeDirectory}/${configDir}";
    cacheHome = "${homeDirectory}/${cacheDir}";
    dataHome = "${homeDirectory}/${dataDir}";
  };

  home.sessionPath = [
    # local bin folder
    "${homeDirectory}/.local/bin"
    # npm bin folder
    "${config.xdg.dataHome}/node_modules/bin"
  ];

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    FZF_BASE = "${pkgs.fzf}/share/fzf";
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    plugins = [{
      # add powerline10 custom config
      name = "p10k-config";
      src = lib.cleanSource ../config/zsh/p10k;
      file = "config.zsh";
    }];

    # enable completion
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      custom = "${config.xdg.configHome}/oh-my-zsh";
      extras = {
        themes = [{
          name = "powerlevel10k";
          source = pkgs.zsh-plugins.powerlevel10k;
        }];
        plugins = [
          {
            name = "fzf-tab";
            source = pkgs.zsh-plugins.fzf-tab;
            config = ''
              # zstyle ':fzf-tab:complete:(cat|bat):*' fzf-preview ' \
              #   ([ -f $realpath ] && ${pkgs.bat}/bin/bat --color=always --style=header,grid --line-range :500 $realpath) \
              #   || ${pkgs.eza}/bin/eza --color=always --tree --level=1 $realpath'

              # ls
              # zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.eza}/bin/eza --color=always --tree --level=1 $realpath'

              # ps/kill
              # give a preview of commandline arguments when completing `kill`
              # zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
              # zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
              # zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
            '';
          }
          {
            name = "fast-syntax-highlighting";
            source = pkgs.zsh-plugins.fast-syntax-highlighting;
          }
        ];
      };
      theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "sudo"
        "git"
        "fzf"
        "zoxide"
        "cp"
      ]
      # ++ [ "fzf-tab" "fast-syntax-highlighting" ] # extra plugins list
        ++ lib.optionals pkgs.stdenv.isDarwin [ "brew" "macos" ]
        ++ lib.optionals pkgs.stdenv.isLinux [ ];
    };

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      # autosuggest color
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

      # tab title
      export ZSH_TAB_TITLE_ONLY_FOLDER=true
      export ZSH_TAB_TITLE_ADDITIONAL_TERMS='iterm|kitty'

      # extra z config
      zstyle ":completion:*:git-checkout:*" sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      #
    '';

    shellAliases = with pkgs;
      let
        ezaTree = lib.listToAttrs (map (i: {
          name = "ls${toString i}";
          value = "ls -T --level=${toString i}";
        }) (lib.range 0 10));
        ezaTreelist = lib.listToAttrs (map (i: {
          name = "l${toString i}";
          value = "ls -T --level=${toString i} -l";
        }) (lib.range 0 10));
      in {
        dev = "(){ nix develop $1 -c $SHELL ;}";
        mydev = "(){ nix develop my#$1 -c $SHELL ;}";

        # kitty alias
        ssh = "${kitty}/bin/kitty +kitten ssh";

        # core alias
        ".." = "cd ..";
        cat = "${bat}/bin/bat";
        du = "${du-dust}/bin/dust";
        rg =
          "${ripgrep}/bin/rg --column --line-number --no-heading --color=always --ignore-case";
        ps = "${procs}/bin/procs";
        # npmadd = "${mynodejs}/bin/npm install --global";
        htop = "${btop}/bin/btop";

        # list dir
        ls = "${eza}/bin/eza";
        l = "ls -l --icons";
        la = "l -a";
        ll = "ls -lhmbgUFH --git --icons";
        lla = "ll -a";
        config = "make -C ${homeDirectory}/nixpkgs";
      } // ezaTree // ezaTreelist
      // (lib.optionalAttrs (stdenv.system == "aarch64-darwin") {
        # switch on rosetta shell
        rosetta-zsh = "${pkgs-x86.zsh}/bin/zsh";

        # yabai & skhd
        restart-yabai =
          "${restart-service}/bin/restart-service org.nixos.yabai.plist";
        restart-skhd =
          "${restart-service}/bin/restart-service org.nixos.skhd.plist";
      });
  };
}
