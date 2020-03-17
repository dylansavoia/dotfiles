;;; ~/.doom.d/mappings.el -*- lexical-binding: t; -*-
(map! :n "j" #'evil-next-visual-line
      :n "k" #'evil-previous-visual-line
      :n "J" #'evil-switch-to-windows-last-buffer
      :v "J" #'evil-join
)


(map! :leader
      (:prefix-map ("t" . "toggle")
        :desc "Flyspell"    "s"  #'flyspell-mode
      )
      (:prefix-map ("s" . "search")
        :desc "Global"    "g"  #'counsel-rg
      )
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

(map! :n "M-h" #'custom-auto-correct-previous-word
      :n "M-l" #'custom-auto-correct-next-word
)
