;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Dylan Savoia"
      user-mail-address "dylansavoia@gmail.com")

;; Doom / Org
(setq doom-theme 'custom)
(setq doom-font (font-spec :family "Liberation Mono" :size 20))
(setq org-directory "~/.doom/org/")

;; GUI
(setq-default line-spacing 0.5)
(setq display-line-numbers-type t)
(setq-default display-line-numbers-width 0)
(global-hl-line-mode 0)

(setq org-startup-indented t)
(setq org-pretty-entities t)
(setq org-ellipsis "  ")
(setq org-bullets-bullet-list '(" "))
(setq-default header-line-format " ")

(yas-global-mode t)
(global-visual-line-mode 1)
(auto-fill-mode -1)

(add-to-list 'default-frame-alist '(internal-border-width . 5))
;; (set-face-attribute 'header-line nil :inherit 'default :background)

(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-selection-wrap-around t)

(setq flyspell-issue-message-flag nil)
(setq lsp-signature-render-documentation nil)

;; MISC
(modify-syntax-entry ?_ "w")
(setq ispell-list-command "--list")
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(load! "hooks.el")
(load! "mappings.el")

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
