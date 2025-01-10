;; I want this really early on so you don't see the startup message
;; flash on the screen before this suppresses it
(setq inhibit-startup-message t)

(require 'org)

;; when using home-manager, config.org will always have mtime of the
;; unix epoch, and org-babel-load-file won't rebuild config.el from
;; config.org if config.el is newer (which it always will be).  So we
;; delete config.el here.
(delete-file (concat user-emacs-directory "config.el"))

;; load the main config file
(org-babel-load-file (concat user-emacs-directory "config.org"))