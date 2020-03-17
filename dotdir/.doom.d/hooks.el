;;; ~/.doom.d/hooks.el -*- lexical-binding: t; -*-

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
