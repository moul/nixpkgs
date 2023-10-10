;;; gno-mode.el --- Major mode for editing GNO files, based on go-mode -*- lexical-binding: t -*-

;; Author: Guilhem Fanton <guilhem.fanton@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "24.3") (go-mode "1.5.0"))
;; Keywords: languages, gno
;; URL: https://github.com/yourusername/gno-mode

;;; Commentary:

;; This package provides a major mode for editing GNO files, which
;; is based on go-mode. It includes additional functions for formatting
;; GNO code using gofumpt.

;;; Code:

(require 'flycheck)
(require 'go-mode)

(defcustom gno-root-dir ""
  "Root directory for GNO lint."
  :type 'directory
  :group 'gno)

(defcustom gno-tab-width 8
  "Width of a tab for GNO mode."
  :type 'integer
  :group 'gno)

;;;###autoload
(define-derived-mode gno-mode go-mode "GNO"
  "Major mode for GNO files, an alias for go-mode."
  (setq-local tab-width gno-tab-width) ;; Use the custom gno-tab-width variable
  ;; FIXME: disable lsp for now
  (when (fboundp 'lsp-disconnect) ;; Check if the lsp-disconnect function is available
    (lsp-disconnect)) ;; lsp doesn't work with gno yet
  (gno-mode-setup))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.gno\\'" . gno-mode))

(defun gno-mode-setup ()
  "Hook for setting up gno-mode."
  (add-hook 'before-save-hook 'gno-format-buffer nil t))

(defun gno-format-buffer ()
  "Format the current buffer using gofumpt. This is an adapted version from go-mode gofmt."
  (interactive)
  (let ((tmpfile (make-nearby-temp-file "gofumpt" nil ".gno"))
        (patchbuf (get-buffer-create "*Gofumpt patch*"))
        (errbuf (get-buffer-create "*Gofumpt Errors*"))
        (coding-system-for-read 'utf-8)
        (coding-system-for-write 'utf-8))

    (unwind-protect
        (save-restriction
          (widen)
          (with-current-buffer errbuf
            (setq buffer-read-only nil)
            (erase-buffer))
          (with-current-buffer patchbuf
            (erase-buffer))
          (write-region nil nil tmpfile)
          (message "Calling gofumpt: %s" tmpfile)
          (if (zerop (call-process "gofumpt" nil errbuf nil "-w" (file-local-name tmpfile)))
              (progn
                (if (zerop (call-process-region (point-min) (point-max) "diff" nil patchbuf nil "-n" "-" tmpfile))
                    (message "Buffer is already gofumpted")
                  (go--apply-rcs-patch patchbuf)
                  (message "Applied gofumpt"))
                (gofmt--kill-error-buffer errbuf))
            (message "Could not apply gofumpt")
            (gofmt--process-errors (buffer-file-name) tmpfile errbuf)))

      (kill-buffer patchbuf)
      (delete-file tmpfile))))

(flycheck-define-checker gno-lint
  "A GNO syntax checker using the gno lint tool."
  :command ("gnolint" "lint"  (eval (concat "--root-dir=" gno-root-dir)) source-original)
  :error-patterns
  ((error line-start (file-name) ":" line ": " (message) " (code=" (id (one-or-more digit)) ")." line-end))
  ;; Ensure the file is saved, to work around
  ;; https://github.com/python/mypy/issues/4746.
  :predicate (lambda ()
               (and (not (bound-and-true-p polymode-mode))
                    (flycheck-buffer-saved-p)))
  :modes gno-mode)

;;;###autoload
(add-to-list 'flycheck-checkers 'gno-lint)
;;;###autoload
(add-hook 'gno-mode-hook
          (lambda ()
            ;; enable flycheck by default
            (flycheck-mode)
            ;; FIXME: disable company for now
            (when (featurep 'company) ; check if company is loaded
              (company-mode -1)) ; disable company mode for gno-mode
            (when (fboundp 'lsp-ui-mode)
              (lsp-ui-mode t))))

;;;###autoload
(define-derived-mode gno-dot-mod-mode go-dot-mod-mode "GNO Mod"
  "Major mode for GNO mod files, an alias for go-dot-mod-mode."
  )

;;;###autoload
(add-to-list 'auto-mode-alist '("gno\\.mod\\'" . gno-dot-mod-mode))


(provide 'gno-mode)

;;; gno-mode.el ends here
