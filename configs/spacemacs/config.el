;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation nil

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d/layers/")

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     osx
     vinegar

     auto-completion
     better-defaults
     ;; helm
     spacemacs-editing
     (ivy :variables ivy-enable-advanced-buffer-information t)

     ;; org
     (org :variables
          org-journal-file-format "%Y-%m-%d"
          org-journal-date-prefix "#+TITLE: "
          org-journal-date-format "%A, %B %d %Y"
          org-journal-time-prefix "* "
          org-journal-time-format ""
          org-projectile-file ".projectile.todos.org"
          org-enable-github-support t
          org-enable-org-journal-support t)
     spacemacs-org

     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-shell 'eshell)

     spell-checking
     syntax-checking
     (treemacs :variables
               treemacs-use-follow-mode t
               treemacs-use-filewatch-mode t)
     docker

     version-control
     git
     tmux
     nixos

     ;; langs
     (go :variables
         go-use-golangci-lint nil ;; disable golangci lint
         go-backend 'lsp
         go-format-before-save nil
         godoc-at-point-function 'godoc-gogetdoc)

     (java :variables java-backend 'lsp)

     prettier
     (javascript :variables
                 javascript-backend 'lsp
                 javascript-fmt-tool 'prettier)

     (typescript :variables
                 typescript-linter 'eslint
                 typescript-backend 'lsp)

     (rust :variables
           rust-backend 'lsp)

     html
     emacs-lisp
     python

     ;; common-lisp TODO: test this
     ruby
     yaml
     markdown
     lsp
     protobuf
     graphql
     swift

     ;; cool stuff
     themes-megapack
     emoji
     deft
     colors
     (multiple-cursors :variables multiple-cursors-backend 'evil-mc)
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(highlight-indent-guides
                                      org-super-agenda)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=~/.emacs.d/.cache/dumps/spacemacs.pdmp
   ;; (default spacemacs.pdmp)
   dotspacemacs-emacs-dumper-dump-file "spacemacs.pdmp"

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; Specify the startup banner. Dfault value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)

   ;; doom
   dotspacemacs-themes '(material)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(all-the-icons
                                  :separator none)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts.
   dotspacemacs-default-font '("PragmataPro Mono Liga"
                               :size 16.0
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir "~/.emacs.d/server"

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env t)
  (setenv "LANG" "en_US.UTF-8") ;; force lang to en_US.UTF-8
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

  ;; packages
  (push "~/.spacemacs.d/packages/pretty-magit/" load-path)
  (push "~/.spacemacs.d/packages/capnp-mode/" load-path)
  (push "~/.spacemacs.d/packages/ansi-mode/" load-path)
  (push "~/.spacemacs.d/packages/framemove/" load-path)
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  (require 'framemove)
  (require 'pretty-magit)
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  ;; lsp
  (require 'lsp)
  (require 'lsp-mode)

  ;; Set up before-save hooks to format buffer and add/delete imports.
  ;; Make sure you don't have other gofmt/goimports hooks enabled.
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

  ;; experimental settings
  (lsp-register-custom-settings
   '(
     ;; common
     ("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t)
     ("gopls.gofumpt" t t)

     ;; experimental
     ;; ("gopls.experimentalWorkspaceModule" t t)
     ))

  ;; use ripgrep as default helm ag search
  ;; (setq
  ;;  helm-ag-base-command "rg -i -M 120 --no-heading --line-number --color never '%s' %s"
  ;;  helm-ag-success-exit-status '(0 2))

  (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-alt-done)

  ;; use aspell istead of ispell
  ;; @FIXME: dont use nixprofil path
  (setq ispell-program-name "aspell")

  ;; force custom variables
  (custom-set-variables
   '(lsp-enable-file-watchers nil)) ;; set file-watchers to nil improve emacs performance

  ;; lsp swift
  (async-start
   ;; check if sourcekit exist
   (lambda ()
     (shell-command-to-string "xcrun --find sourcekit-lsp 2>/dev/null"))

   ;; register swift lsp client
   (lambda (lsp-sourcekit-executable)
     (if (= (length lsp-sourcekit-executable) 0)
         (message "no sourcekit-lsp detected for swift: skipping ")
       (progn
         (lsp-register-client
          (make-lsp-client :new-connection (lsp-stdio-connection '("xcrun" "sourcekit-lsp"))
                           :major-modes '(swift-mode)
                           :server-id 'sourcekit-lsp))
         )
       )))
  (add-hook 'swift-mode-hook #'lsp)

  ;; ivy

  ;; doom-org
  ;; Corrects (and improves) org-mode's native fontification.
  ;; (doom-themes-org-config)

  ;; hightlight indent guide
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-responsive 'top)
  (defun my-highlighter (level responsive display)
    (if (> 1 level)
        nil
      (highlight-indent-guides--highlighter-default level responsive display)))

  (setq highlight-indent-guides-highlighter-function 'my-highlighter)
  (setq highlight-indent-guides-character ?.)

  ;; framemove
  (require 'framemove)
  (windmove-default-keybindings)
  (setq framemove-hook-into-windmove t)

  ;; windmove
  (when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings))

  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right)

  ;; disable xterm mouse mode
  (xterm-mouse-mode -1)

  ;; imenu
  (setq imenu-list-focus-after-activation nil)

  ;; alist mode

  ;; objc
  (add-to-list 'auto-mode-alist '("\\.m$" . objc-mode))

  ;; tsx
  (add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-tsx-mode))
  (add-to-list 'auto-mode-alist '("\\.ts$" . typescript-mode))

  ;; capn
  (require 'capnp-mode)
  (add-to-list 'auto-mode-alist '("\\.capnp\\'" . capnp-mode))

  ;; ansi-mode
  (require 'ansi-color)
  (define-minor-mode ansi-color-mode
    "..."
    :init-value nil
    :global nil
    :group 'ansi-color
    :lighter " ansimode"
    :keymap nil
    (let ((old-buffer (current-buffer))
          (temp-buffer (concat "*" (buffer-name) "*")))
      (with-current-buffer (get-buffer-create temp-buffer)
        (barf-if-buffer-read-only)
        (erase-buffer)
        (save-excursion
          (insert-buffer-substring old-buffer))
        (switch-to-buffer temp-buffer t)
        (ansi-color-apply-on-region 1 (buffer-size))
        (kill-buffer old-buffer)
        (delete-trailing-whitespace)
        (end-of-buffer))))
  (add-to-list 'auto-mode-alist '("\\.ansi\\'" . ansi-color-mode))


  ;; Projectile

  ;; Once you have selected your project, the top-level directory
  ;; of the project is immediately opened for you in a dired buffer.

  (setq projectile-switch-project-action 'projectile-dired)

  ;; keybindings

  (global-set-key (kbd "C-x k") 'spacemacs/kill-this-buffer)

  ;; @TODO: move this elsewhere
  ;; (defun org-journal-save-entry-and-exit()
  ;;   "Simple convenience function.
  ;; Saves the buffer of the current day's entry and kills the window
  ;; Similar to org-capture like behavior"
  ;;   (interactive)
  ;;   (save-buffer)
  ;;   (kill-buffer-and-window))
  ;; (define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

  ;; authinfo
  (setq auth-sources '("~/.authinfo"))

  ;; org

  (setq org-folder "~/org/")

  (setq deft-directory (concat org-folder "notes/"))
  ;; (setq org-journal-dir (concat org-folder "journal/"))
  ;; (setq org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|\\\([0-9]-?\\\)\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")
  ;; (setq org-agenda-files (list org-journal-dir
  ;;                              org-directory
  ;;                              deft-directory))

  ;;  set todo sequences
  ;; (setq org-todo-keywords
        ;; '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "DONE(d)")))


  ;; add project todo to agenda @NOTE(gfanton) this may be more confusing than anything
  ;; (with-eval-after-load 'org-agenda
  ;;   (require 'org-projectile)
  ;;   (mapcar '(lambda (file)
  ;;              (when (file-exists-p file)
  ;;                (push file org-agenda-files)))
  ;;           (org-projectile-todo-files))
  ;;   (setq org-agenda-prefix-format '(
  ;;                                    ;; (agenda  . " %i %-12:c%?-12t% s") ;; file name + org-agenda-entry-type
  ;;                                    (agenda  . "%e • %i %-12:c%?-12t% s %-12T")
  ;;                                    (timeline  . "  % s")
  ;;                                    (todo  . " %i %-12:c")
  ;;                                    (tags  . " %i %-12:c")
  ;;                                    (search . " %i %-12:c")))

    ;; set super agenda group
    ;; (setq org-super-agenda-groups
    ;;       '(
    ;;         (:name "Projects IN-PROGRESS"  ; Optionally specify section name
    ;;                :time-grid t  ; Items that appear on the time grid
    ;;                :and (:tag "project" :todo "STARTED")
    ;;                :log t)

    ;;         (:name "Projects TODO"  ; Optionally specify section name
    ;;                :tag "project"
    ;;                :todo ("TODO" "DONE")
    ;;                :log t)

    ;;         (:name "Projects ON-HOLD"  ; Optionally specify section name
    ;;                :time-grid t  ; Items that appear on the time grid
    ;;                :tag "project"
    ;;                :todo "WAITING"
    ;;                :log t)

    ;;         (:name "Life"
    ;;                ;; Single arguments given alone
    ;;                :tag "life")
    ;;         (:auto-tags)))

    ;; enable org-super-agenda
    ;; (org-super-agenda-mode))

  ;; (require 'org-expiry)
  ;; (add-hook 'org-after-todo-state-change-hook
  ;;           (lambda ()
  ;;             (when (string= org-state "STARTED")
  ;;               (save-excursion
  ;;                 (org-back-to-heading)
  ;;                 (org-expiry-insert-created)))))

  ;; (setq org-journal-carryover-items "/+TODO|+STARTED|+WAITING")

  ;; regexp
  ;; set pcre as default
  (pcre-mode)
  (custom-set-variables
   '(vr/engine (quote pcre2el)))

  ;; Private File
  (if (boundp 'dotspacemacs-private-file)
      (load-file dotspacemacs-private-file))

  ;; open agenda
  ;; (org-agenda nil "a")
  ;; Adding this to ~/.emacs.d/init.el gave me a transparent emacs:

  ;; all the icons customize
  (setq spaceline-all-the-icons-flycheck-alternate t)
  (setq spaceline-all-the-icons-hide-long-buffer-path t)
  (setq spaceline-all-the-icons-slim-render t)
  (spaceline-toggle-all-the-icons-eyebrowse-workspace-off)
  (spaceline-toggle-all-the-icons-window-number-off)


  ;; fix main theme with daemon
  (if (daemonp)
      (cl-labels ((load-material (frame)
                             (with-selected-frame frame
                               (load-theme 'material t))
                             (remove-hook 'after-make-frame-functions #'load-material)))
        (add-hook 'after-make-frame-functions #'load-material))
    (load-theme 'material t))

  ;; end
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
