;;; testscripts-mode.el --- A polymode for Testscriptss -*- lexical-binding: t; -*-

;; Author: Your Name <your.email@example.com>
;; URL: https://github.com/yourusername/testscripts-mode
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

(define-innermode testscripts-go-innermode
  :mode 'go-mode
  :head-matcher "^-- [^.]+.go --$"
  :tail-matcher "\\(^-- [^.]+ --$\\)\\|\\'")

(define-innermode testscripts-gno-innermode
  :mode 'gno-mode
  :head-matcher "^-- [^.]+.gno --$"
  :tail-matcher "\\(^-- [^.]+ --$\\)\\|\\'")

(define-innermode testscripts-golden-innermode
  :mode 'text-mode
  :head-matcher "^-- [^.]+.golden --$"
  :tail-matcher "\\(^-- [^.]+ --$\\)\\|\\'")

;; Define the polymode
(define-polymode testscripts-mode-polymode
  :hostmode 'testscripts-bash-hostmode
  :innermodes '(testscripts-go-innermode
                testscripts-gno-innermode
                testscripts-golden-innermode))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.txtar\\'" . testscripts-mode-polymode))

;;;###autoload
(defun testscripts-mode ()
  "Activate the Testscripts polymode."
  (interactive)
  (testscripts-mode-polymode))

(provide 'testscripts-mode)

;;; testscripts-mode.el ends here
