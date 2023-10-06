;;; gno.el --- Main entry point for GNO package -*- lexical-binding: t -*-

;; Author: Guilhem Fanton <guilhem.fanton@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "24.3") (go-mode "1.5.0") (lsp-mode "6.3.2"))
;; Keywords: languages, gno
;; URL: https://github.com/gfanton/gno-mode

;;; Commentary:

;; This is the main entry point for the GNO package.
;; It provides a major mode for editing GNO files, LSP support, and other related utilities.

;;; Code:

(require 'gno-mode)
(require 'testscripts-mode)

;; Setup lsp-gno
;; (lsp-gno-setup)

(provide 'gno)

;;; gno.el ends here

