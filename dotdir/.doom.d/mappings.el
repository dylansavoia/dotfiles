;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Functions              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun org-insert-clipboard-image ()
  (interactive)
  (setq uuid (string-trim (shell-command-to-string "uuidgen")))
  (shell-command "mkdir -p ./images")
  (shell-command-to-string (concat "xclip -selection clipboard -t image/jpg -o > ./images/" uuid ".jpg" ))
  (insert (concat "[[file:./images/" uuid ".jpg]]"))
  (org-display-inline-images)
)

(defun custom-auto-correct-next-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (evil-next-flyspell-error 1)
  (flyspell-auto-correct-word)
)
(defun custom-auto-correct-previous-word ()
  "Custom function to spell check next highlighted word"
  (interactive)
  (evil-prev-flyspell-error 1)
  (flyspell-auto-correct-word)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Mappings               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(map! :leader
      (:prefix-map ("t" . "toggle")
        :desc "Flyspell"    "s"  #'flyspell-mode
      )
      (:prefix-map ("s" . "search")
        :desc "Global"    "g"  #'counsel-rg
      )
)

(map!
      :n "j" #'evil-next-visual-line
      :n "k" #'evil-previous-visual-line
      :n "J" #'evil-switch-to-windows-last-buffer
      :v "J" #'evil-join
)

(with-eval-after-load 'org
  (map! :n "<M-left>" #'custom-auto-correct-previous-word
        :n "<M-right>" #'custom-auto-correct-next-word
        :i "C-v" #'org-insert-clipboard-image
  )
)
