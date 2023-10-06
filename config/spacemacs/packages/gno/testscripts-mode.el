;;; testscripts-mode.el --- A polymode for Testscriptss -*- lexical-binding: t; -*-

;; Author: Your Name <8671905+gfanton@users.noreply.github.com>
;; URL: https://github.com/gfanton/gno-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1") (polymode "0.2.2"))
;; Keywords: languages, polymode, testscriptss

;;; Commentary:

;; This package provides a polymode for Testscripts. Testscripts files with
;; extension .txtar will have sections highlighted in sh-mode, go-mode,
;; gno-mode, and text-mode based on section headers.

;;; Code:

(require 'polymode)

;; Define host and inner modes
(define-hostmode testscripts-bash-hostmode
  :mode 'sh-mode)

(define-auto-innermode testscripts-auto-innermode
  :can-overlap t
  :can-nest t
  :head-matcher "^-- [^.]+.[[:alpha:]]+\\(.golden\\)? --$"
  :tail-matcher "\\(^-- [^ ]+ --$\\)\\|\\'"
  :mode-matcher (cons "^-- [^.]+\\.\\([[:alpha:]]+\\)\\(.golden\\)? --$" 1)
  :fallback-mode 'text-mode
  )

;; Define the polymode
(define-polymode testscripts-mode-polymode
  :hostmode 'testscripts-bash-hostmode
  :innermodes '(testscripts-auto-innermode))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.txtar\\'" . testscripts-mode-polymode))

;;;###autoload
(defun testscripts-mode ()
  "Activate the Testscripts polymode."
  (interactive)
  (testscripts-mode-polymode))

(provide 'testscripts-mode)

;;; testscripts-mode.el ends here
