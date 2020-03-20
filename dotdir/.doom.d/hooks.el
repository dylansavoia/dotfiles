;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Functions              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun custom-save-cmd ()
  "Execute on Save."
  (when (equal buffer-file-truename "~/.Xresources")
      (shell-command-to-string "xrdb ~/.Xresources")
  )
)

(defun restyle-margins () (progn
  (setq left-margin-width 2)
  (setq right-margin-width 2)
  (set-window-buffer nil (current-buffer))
))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                Hooks                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(after! text-mode
  (set-company-backend! 'text-mode '(company-yasnippet company-dabbrev company-capf))
)

(after! prog-mode
  (set-company-backend! 'prog-mode '(company-capf company-yasnippet company-dabbrev))
)

(add-hook 'prog-mode-hook #'lsp-deferred)
(add-hook 'lsp-mode-hook #'lsp-ui-mode)
(add-hook 'lsp-mode-hook (lambda ()
  (setq company-backends (cdr company-backends))
) 1)


(add-hook 'org-mode-hook 'org-fragtog-mode)
(add-hook 'after-save-hook #'custom-save-cmd)
(add-hook 'text-mode-hook #'restyle-margins)

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))
