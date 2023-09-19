;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.
(let* ((dotspacemacs-basedir (file-name-directory (or load-file-name buffer-file-name)))

       ;; Main file.
       (dotspacemacs-config-file (concat dotspacemacs-basedir "config.el"))

       ;; Custom file.
       (dotspacemacs-custom-file (concat dotspacemacs-basedir "custom.el"))

       ;; Private file
       (dotspacemacs-private-file (concat dotspacemacs-basedir "private.el")))

  (unless (file-exists-p dotspacemacs-custom-file)
    (write-region "" nil dotspacemacs-custom-file))

  (unless (file-exists-p dotspacemacs-private-file)
    (write-region "" nil dotspacemacs-private-file))

  (setq custom-file dotspacemacs-custom-file)

  (load dotspacemacs-config-file)
  (load dotspacemacs-custom-file))
