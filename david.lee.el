(message "Loading my own stuff")

;;----------------------------------------------------------------------------
;; Load Libraries
;;----------------------------------------------------------------------------

(add-to-list 'load-path (concat dotfiles-dir "/custom"))

(require 'color-theme)
(load "color-theme-sore-eyes")  
;(color-theme-sore-eyes)
    
;;----------------------------------------------------------------------------
;; Functions
;;----------------------------------------------------------------------------

(defun kill-buffers ()
  (interactive "")
  "Kill all existing live buffers which have not been modified."
  (setq list (buffer-list))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
           (/= (aref name 0) ? )
           (not (buffer-modified-p buffer))
           (kill-buffer buffer)))
    (setq list (cdr list))))

(defun diff-current-buffer-with-file ()
  (interactive "")
  (diff-buffer-with-file (current-buffer)))

;; make tab completion not suck
;; (global-set-key [(tab)] 'smart-tab)

;; TODO this crashes the fuck out of org-mode
;; FIXME need to make it call org-cycle if in org-mode
(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
  (interactive)
    (if (minibufferp)
        (unless (minibuffer-complete)
          (dabbrev-expand nil))
      (if mark-active
          (indent-region (region-beginning)
                         (region-end))
        (if (looking-at "\\_>")
            (dabbrev-expand nil)
          (indent-for-tab-command)))))

(defun toggle-window-split ()
  "Vertical split shows more of each line, horizontal split shows
more lines. This code toggles between them. It only works for
frames with exactly two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
             (if (= (car this-win-edges)
                    (car (window-edges (next-window))))
                 'split-window-horizontally
               'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))            

(defun writeroom ()
  "Switches to a WriteRoom-like fullscreen style"
  (interactive)
  (when (featurep 'aquamacs)
    (aquamacs-toggle-full-frame)))
    
(defalias 'wtf 'describe-mode)

;;-----------------------------------------------------------------------------
;; Defaults
;;-----------------------------------------------------------------------------

(setq-default
 auto-insert-mode nil                  ; templates for new files
 auto-fill-mode nil                    ; turn off auto-fill by default
 c-default-style "k&r"                 ;
 c-basic-indent 2
 column-number-mode 1
 dabbrev-abbrev-skip-leading-regexp "^:"
 dabbrev-case-fold-search nil
 dabbrev-case-replace nil
 case-fold-search t                    ; case-insensitive search
 comment-auto-fill-only-comments t
 debug-on-error nil                    ; NO! stop interrupting me
 debug-on-signal nil
 javascript-indent-level 2
 delete-by-moving-to-trash nil
 font-lock-mode t
 font-lock-maximum-decoration t        ; life is a colouring book
 frame-title-format "emacs - %b"       ; show buffer name in title
 global-font-lock-mode t
 indent-tabs-mode nil
 inhibit-splash-screen t               ; don't show the ugly buffalo
 interprogram-paste-function 'x-cut-buffer-or-selection-value
 ls-lisp-dirs-first t                  ; display dirs first in dired
 make-backup-files nil                 ; don't litter
 mark-even-if-inactive t
 menu-bar-mode nil
 org-startup-folded nil
 pc-select-meta-moves-sexps t
 pc-select-selection-keys-only t
 pc-selection-mode nil
 query-replace-highlight t             ; highlight all matches on page
 require-final-newline t               ; can't hurt, can help
 search-highlight t
 set-mark-command-repeat-pop t         ; C-u C-spc-spc-spc ...
 scroll-bar-mode nil
 show-paren-mode t
 show-trailing-whitespace t
 truncate-lines t                      ; nowrap
 tab-width 2
 transient-mark-mode nil
 tool-bar-mode nil
 vc-follow-symlinks t                  ; follow symlinks without asking
 viper-mode nil
 viper-inhibit-startup-message t
 viper-expert-level 5
 viper-shift-width 2
 visible-bell t
 uniquify-buffer-name-style 'post-forward
 uniquify-strip-common-suffix nil
 x-select-enable-clipboard t           ; use system clipboard
 truncate-partial-width-windows nil    ; will truncate even when screen is split into multiple windows
 zone-leave-me-alone t )               ; grr debian

;; delete extra whitespace on save
(add-hook 'before-save-hook
         'delete-trailing-whitespace)

;; enable commands disabled by default
(put 'upcase-region   'disabled nil)
(put 'downcase-region 'disabled nil)

;; don't make me type 'yes'
(fset 'yes-or-no-p 'y-or-n-p)

(winner-mode 1)
(auto-compression-mode 1)

(prefer-coding-system 'utf-8)

;(color-theme-initialize)
(color-theme-sore-eyes)
(font-lock-mode t)

(setq tramp-default-method "ssh")

;;; Shell mode
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

(setq rinari-tags-file-name "TAGS")


;; Interactively Do Things
;(ido-mode t)
;(ido-mode 'buffer)
;(setq ido-enable-flex-matching t)

(defun gui-only-settings()
  (message "applying gui-only-settings")
  (setq scroll-bar-mode nil))

(defun console-only-settings ()
  (interactive)
  (require 'xt-mouse)
  (xterm-mouse-mode t)
  (mouse-wheel-mode t)
  (if (load "mwheel" t)
      (mwheel-install))
  ;(color-theme-initialize)
  ;(color-theme-hober)
  )

(if window-system-version
    (gui-only-settings)
    (console-only-settings))
    
(setenv "EMACS" "t") ; so zsh, screen etc can depend on this

;;-----------------------------------------------------------------------------
;; Keybindings
;;-----------------------------------------------------------------------------

;; bindings for built-ins

(global-set-key (kbd "C-<next>")  'next-buffer)
(global-set-key (kbd "C-<prior>") 'previous-buffer)

(global-set-key (kbd "C-c o") (lambda () (interactive) (other-window -1))) ;; back one
(global-set-key "\C-cw" 'toggle-truncate-lines)

;; bindings for built-ins
(global-set-key "\C-x\M-k" 'dml/kill-buffers)

;; M-x without meta
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

(global-set-key "\C-c\C-m" 'execute-extended-command) ; M-x
(global-set-key "\C-hw" 'command-history)
(global-set-key "\C-ch" 'hide-lines)

;; control left / right
(global-set-key (quote [C-right]) (quote forward-sexp))
(global-set-key (quote [C-left]) (quote backward-sexp))

(global-set-key (quote [tab]) 'smart-tab)

;; C-c
(global-set-key "\C-co" 'dml/go-back-window)
(global-set-key "\C-cw" 'dml/toggle-word-wrap)
(global-set-key "\C-cw" 'dml/toggle-word-wrap)

(global-set-key [f1] (lambda (n) (interactive "p") (set-selective-display n)))
(global-set-key [f2] 'shell-toggle)

(global-set-key [f7]  'dml/cycle-font )
(global-set-key [f8]  'highlight-changes-mode )
(global-set-key [f9]  'toggle-truncate-lines )
(global-set-key [f10] 'diff-buffer-with-file )
(global-set-key [f11] 'diff-current-buffer-with-file )
(global-set-key [f12] 'rinari-find-rspec )