;;
;; color-theme-sore-eyes.el
;;
;; Made by David Lee
;; Login   <dml@thumper.rev.kgpn.10.in-addr.arpa>
;;
;; Started on  Mon Jul 21 12:05:27 2008 David Lee
;; Last update Mon Jul 21 12:05:27 2008 David Lee
;;
(eval-when-compile
  (require 'color-theme))

(defun color-theme-sore-eyes ()
  "Sore_Eyes"
  (interactive)
  (color-theme-install
   '(color-theme-sore-eyes
     ((foreground-color . "#222222")
      (background-color . "#f3f9f7")
      (Background-mode . light))
     (default ((t (nil))))

     (region ((t (:foreground "white" :background "#993355"))))

     (underline ((t (:foreground "dark orange" :underline t))))
     (modeline ((t (:foreground "#dddddd" :background "#555555"))))

     (modeline-buffer-id ((t (:foreground "yellow" :background "#333333"))))
     (modeline-mousable ((t (:foreground "yellow" :background "#333333"))))
     (modeline-mousable-minor-mode ((t (:foreground "dark red" :background "black"))))
     (mode-line-inactive ((t (:foreground "#555555" :background "#bbbbbb"))))

     (italic ((t (:foreground "dark red" :italic t))))
     (bold-italic ((t (:foreground "dark red" :bold t :italic t))))
     (bold ((t (:bold))))

     (erb-delim-face ((t (:background "snow3" :foreground "yellow"))))
     (erb-exec-delim-face ((t (:inherit erb-delim-face :background "black" :foreground "red" :weight bold))))
     (erb-exec-face ((t (:inherit erb-face :background "black"))))
     (erb-out-delim-face ((t (:inherit erb-delim-face :background "black" :foreground "yellow" :weight bold))))
     (erb-out-face ((t (:inherit erb-face :background "black"))))

     (flymake-errline ((((class color)) (:background "#ffdede" :underline "red"))))
     (flymake-warnline ((((class color)) (:background "yellow"))))

     (trailing-whitespace ((((class color)) (:background "white"))))

     (font-lock-builtin-face ((((class color) (background light)) (:foreground "darkgreen"))))
     (font-lock-comment-face ((t (:foreground "red" :background "White"))))
     (font-lock-constant-face ((((class color) (background light)) (:bold t :foreground "DarkOrchid"))))
     (font-lock-doc-string-face ((t (:foreground "#555555"))))
     (font-lock-function-name-face ((t (:foreground "Blue"))))
     (font-lock-keyword-face ((t (:bold t :foreground "#3355ee"))))
     (font-lock-preprocessor-face ((t ( :background "White"))))
     (font-lock-string-face ((t (:foreground "ForestGreen"))))
     (font-lock-type-face ((t (:foreground "#994422"))))
     (font-lock-variable-name-face ((t (:foreground "DarkRed"))))
     (font-lock-warning-face ((((class color) (background light)) (:foreground "red" :background "#ffdede"))))

     (highlight-changes ((t (:background "red" :foreground "yellow"))))

     (paren-match ((t (:background "red"))))

     (show-paren-match ((t (:foreground "black" :background "red"))))
     (show-paren-match-face ((t (:foreground "black" :background "red"))) t)
     (show-paren-mismatch ((((class color)) (:foreground "red" :background "red"))))
     (show-paren-mismatch-face ((((class color)) (:foreground "white" :background "orange"))) t)

     (speedbar-button-face ((((class color) ()) (:foreground "darkred"))))
     (speedbar-directory-face ((((class color) ()) (:foreground "darkgreen"))))
     (speedbar-file-face ((((class color) ()) (:foreground "grey"))))
     (speedbar-tag-face ((((class color) ()) (:foreground "red"))))

     (org-special-keyword ((t (:bold t :foreground "#ff0000" :background "#ffffff"))))
     (org-link ((t (:bold t :foreground "red" :background "#ffffff"))))
     (org-level-1 (( t(:bold t :foreground "#000000"))))
     (org-level-2 (( t(:foreground "#0033aa"))))
     (org-level-3 (( t(:foreground "#113355"))))
     (org-level-4 (( t(:foreground "#555555"))))
     (org-level-5 (( t(:foreground "#557799"))))
     (org-level-6 (( t(:foreground "#777777"))))
     (org-level-7 (( t(:foreground "#7999aa"))))
     (org-level-8 (( t(:foreground "#999999"))))

     (speedbar-button-face ((((class color) (background light)) (:foreground "#333333"))))
     (speedbar-directory-face ((((class color) (background light)) (:foreground "blue"))))
     (speedbar-file-face ((((class color) (background light)) (:foreground "#555555"))))
     (speedbar-tag-face ((((class color) (background light)) (:foreground "green"))))

     (vhdl-speedbar-architecture-face ((((class color) (background light)) (:foreground "darkblue"))))
     (vhdl-speedbar-architecture-selected-face ((((class color) (background light)) (:underline t :foreground "Blue"))))
     (vhdl-speedbar-entity-face ((((class color) (background light)) (:foreground "darkGreen"))))
     (vhdl-speedbar-entity-selected-face ((((class color) (background light)) (:underline t :foreground "darkGreen"))))
     (vhdl-speedbar-instantiation-face ((((min-colors 88) (class color) (background light)) (:foreground "#335577"))))
     (vhdl-speedbar-instantiation-selected-face ((((class color) (background light)) (:foreground "forestgreen" :underline t))))
     (vhdl-speedbar-library-face ((((class color) (background light)) (:foreground "purple"))))
     (vhdl-speedbar-package-face ((((class color) (background light)) (:foreground "black"))))
     (vhdl-speedbar-package-selected-face ((((class color) (background light)) (:underline t :foreground "black"))))
     (vhdl-speedbar-subprogram-face ((((class color) (background light)) (:foreground "#337755"))))

     (highline-face ((((:background "#ffffff")))))
     (hl-line-face ((((:background "#ffffff")))))
     (highlight ((t ((:background "#ffffff")))))

     (widget-field ((((class grayscale color) (background light)) (:background "#ccffcc"))))))

  ;; and then ..
  (setq highline-face '(:background "#ffffff"))
  (setq hl-line-face '(:background "#ffffff"))
  (set-face-background 'highlight "white")
  )
(provide 'color-theme-sore-eyes)

(color-theme-sore-eyes)
