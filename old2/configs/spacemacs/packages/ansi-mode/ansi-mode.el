;;; ansi-mode.el --- minor mode for ansi buffer

;; This is free and unencumbered software released into the public domain.

;; Author: Brian Taylor <el.wubo@gmail.com>
;; Version: 1.0.0

;;; Commentary:

;; Provides basic syntax highlighting for capnp files.
;;
;; To use:
;;
;; Add something like this to your .emacs file:
;;

;; (require 'ansi-color-mode)
;; (add-to-list 'auto-mode-alist '("\\.ansi\\'" . ansi-color-mode))
;;

;;; Code:
(require 'ansi-color)
(define-minor-mode ansi-color-mode
  "..."
  :init-value nil
  :lighter nil
  :keymap nil
  (ansi-color-apply-on-region 1 (buffer-size))
  (read-only-mode 1))

(provide 'ansi-mode)
