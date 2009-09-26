;;
;; color-theme-dml.el
;;
;; Made by David Lee
;; Login   <dml@thumper.rev.kgpn.10.in-addr.arpa>
;;
;; Started on  Mon Jul 21 12:05:27 2008 David Lee
;; Last update Mon Jul 21 12:05:27 2008 David Lee
;;
(eval-when-compile
  (require 'color-theme))

(defun color-theme-dml ()
  "Sweet_charcoal"
  (interactive)
  (color-theme-install
   '(color-theme-dml
     ((foreground-color . "#dedede")
      ;; (background-color . "#191920")
      (background-color . "#131510")
      (background-mode . dark))
     (default ((t (nil))))

     (region ((t (:foreground "red" :background "black"))))
     (underline ((t (:foreground "yellow" :underline t))))
     (modeline ((t (:foreground "#ddd" :background "black"))))
     (modeline-buffer-id ((t (:foreground "red" :background "#222"))))
     (modeline-mousable ((t (:foreground "red" :background "#222"))))
     (modeline-mousable-minor-mode ((t (:foreground "dark red" :background "wheat"))))
     (italic ((t (:foreground "dark red" :italic t))))
     (bold-italic ((t (:foreground "dark red" :bold t :italic t))))
     (font-lock-comment-face ((t (:foreground "#457" :background "Black"))))
     (bold ((t (:bold))))

     (erb-delim-face ((t (:background "snow3" :foreground "yellow"))))
     (erb-exec-delim-face ((t (:inherit erb-delim-face :background "black" :foreground "red" :weight bold))))
     (erb-exec-face ((t (:inherit erb-face :background "black"))))
     (erb-out-delim-face ((t (:inherit erb-delim-face :background "black" :foreground "yellow" :weight bold))))
     (erb-out-face ((t (:inherit erb-face :background "black"))))
     (flymake-errline ((((class color)) (:background "dark red" :underline "yellow"))))
     (flymake-warnline ((((class color)) (:background "#330" :foreground "white"))))

     (font-lock-builtin-face ((((class color) (background dark)) (:foreground "darkgreen"))))
     (font-lock-comment-face ((t (:foreground "#777") (:background "#000"))))
     (font-lock-constant-face ((((class color) (background dark)) (:bold t :foreground "DarkOrchid"))))
     (font-lock-doc-string-face ((t (:foreground "#999"))))
     (font-lock-function-name-face ((t (:foreground "SkyBlue"))))
     (font-lock-keyword-face ((t (:bold t :foreground "CornflowerBlue"))))
     (font-lock-preprocessor-face ((t (:italic nil :foreground "yellow"))))
     (font-lock-string-face ((t (:foreground "LimeGreen"))))
     (font-lock-type-face ((t (:foreground "#9290ff"))))
     (font-lock-variable-name-face ((t (:foreground "PaleGreen"))))
     (font-lock-warning-face ((((class color) (background dark)) (:foreground "yellow" :background "red"))))

     (nxml-attribute-local-name-face ((t (:foreground "#777755"))))
     (nxml-element-local-name-face ((t (:foreground "#557799"))))
     (nxml-element-prefix-face ((t (:foreground "#335577"))))
     (nxml-tag-delimiter-face ((t (:foreground "#997755"))))

     (paren-match ((t (:background "red"))))
     (show-paren-match ((t (:foreground "black" :background "red"))))
     (show-paren-match-face ((t (:foreground "black" :background "red"))) t)
     (show-paren-mismatch ((((class color)) (:foreground "red" :background "cyan"))))
     (show-paren-mismatch-face ((((class color)) (:foreground "white" :background "cyan"))) t)

     (speedbar-button-face ((((class color) (background dark)) (:foreground "green4"))))
     (speedbar-directory-face ((((class color) (background dark)) (:foreground "khaki"))))
     (speedbar-file-face ((((class color) (background dark)) (:foreground "cyan"))))
     (speedbar-tag-face ((((class color) (background dark)) (:foreground "Springgreen"))))

     (org-special-keyword ((t (:bold t :foreground "#ffffff" ))))
     (org-link ((t (:bold t :background "red" :foreground "#ffffff"))))
     (org-done ((t (:bold t :background "darkgreen" :foreground "#ffffff"))))
     (org-todo ((t (:bold t :background "red" :foreground "#ffffff"))))
     (org-level-8 (( t(:bold t :foreground "#eeeeee"))))
     (org-level-7 (( t(:foreground "#0033aa"))))
     (org-level-6 (( t(:foreground "#113355"))))
     (org-level-5 (( t(:foreground "#555555"))))
     (org-level-4 (( t(:foreground "#557799"))))
     (org-level-3 (( t(:foreground "#777777"))))
     (org-level-2 (( t(:foreground "#7999aa"))))
     (org-level-1 (( t(:foreground "#999999"))))

     (widget-field ((((class grayscale color) (background light)) (:background "#cfc")))))))

(setq highline-face '(:background "#111"))
(setq hl-line-face '(:background "#111"))
(set-cursor-color "red")

(provide 'color-theme-dml)
(color-theme-dml)
