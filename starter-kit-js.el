;;; starter-kit-js.el --- Some helpful Javascript helpers
;;
;; Part of the Emacs Starter Kit

(add-to-list 'load-path (concat dotfiles-dir "/vendor"))

(font-lock-add-keywords
 'js2-mode `(("\\(function *\\)("
                   (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                             "ƒ")
                             nil)))))

(font-lock-add-keywords 'js2-mode
                        '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\):"
                           1 font-lock-warning-face t)))

(autoload 'js2-mode "js2" "Start js2-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(add-hook 'js2-mode-hook 'moz-minor-mode)
;(add-hook 'js2-mode-hook 'esk-paredit-nonlisp)
(add-hook 'js2-mode-hook 'run-coding-hook)
(add-hook 'js2-mode-hook 'idle-highlight)
(setq js2-indent-level 2)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; js2's insert-and-indent doesn't play nicely with pretty-lambda
;(eval-after-load 'js2
;  '(progn (define-key js2-mode-map "{" 'paredit-open-brace)
;          (define-key js2-mode-map "}" 'paredit-close-brace-and-newline)))

(provide 'starter-kit-js)
;;; starter-kit-js.el ends here
