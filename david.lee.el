(message "Loading my own stuff")

(set-default-font #("-apple-consolas-medium-r-normal--0-0-0-0-m-0-iso10646-1" 0 15 (face icicle-match-highlight-minibufferbsc) 15 55 nil) nil)

;; twitter
(autoload 'twitter-get-friends-timeline "twitter" nil t)
(autoload 'twitter-status-edit "twitter" nil t)
(global-set-key "\C-xt" 'twitter-get-friends-timeline)
(add-hook 'twitter-status-edit-mode-hook 'longlines-mode)


;; ERC

(defmacro de-erc-connect (command server port nick)
  "Create interactive command `command', for connecting to an IRC server. The
      command uses interactive mode if passed an argument."
  (fset command
        `(lambda (arg)
           (interactive "p")
           (if (not (= 1 arg))
               (call-interactively 'erc)
             (erc :server ,server :port ,port :nick ,nick)))))

(autoload 'erc "erc" "" t)
(de-erc-connect erc-fre "irc.freenode.net" 6666 "davidlee")
(de-erc-connect erc-meo "irc.meobets.com" 6666 "davidlee")
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
  '((".*\\.freenode.net" "#emacs" "#roro" "#pancake" "#chef")
    (".*\\.meobets.com" "#offandracing" "#passengers")))
;;
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                 "324" "329" "332" "333" "353" "477"))
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))


(defvar growlnotify-command (executable-find "growlnotify") "/usr/bin/growlnotify")

(defun growl (title message)
  (start-process "growl" " growl"
                 growlnotify-command
                 title
                 "-a" "Emacs")
  (process-send-string " growl" message)
  (process-send-string " growl" "\n")
  (process-send-eof " growl"))

(defun my-erc-hook (match-type nick message)
  "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
  (unless (posix-string-match "^\\** *Users on #" message)
    (growl
     (concat "ERC: name mentioned on: " (buffer-name (current-buffer)))
     message
     )))

(add-hook 'erc-text-matched-hook 'my-erc-hook)

;;----------------------------------------------------------------------------
;; Load Libraries
;;----------------------------------------------------------------------------

(add-to-list 'load-path (concat dotfiles-dir "/custom"))
(add-to-list 'load-path (concat dotfiles-dir "/rinari"))
(add-to-list 'load-path (concat dotfiles-dir "/icicles"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor/tuareg-mode"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor/rsense"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor/auto-complete"))
(setq rsense-home (concat dotfiles-dir "/vendor/rsense"))
(require 'auto-complete)

(global-set-key (kbd "C-c C-c")  'ac-complete-rsense)
(global-set-key (kbd "C-c C-v") 'rsense-complete)

(require 'icicles)
(icicle-mode)

;; this path stuff seems to have to happen after icicles is loaded
;;  (add-to-list 'load-path (concat dotfiles-dir "/vendor/cedet"))
;;  (add-to-list 'load-path (concat dotfiles-dir "/vendor/ecb"))
;;  (require 'ecb-autoloads)
;;
;;  (load "common/cedet.el")
;;  (global-ede-mode 1)                      ; Enable the Project management system
;;  (semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion
;;  (global-srecode-minor-mode 1)            ; Enable template insertion menu

;;
(ido-mode nil)
(require 'filecache)
(require 'rinari)
(require 'haml-mode)

;; (add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode))

;; (require 'git)

(setq viper-mode nil)
(require 'viper)                  ; just load it, for viper-join-lines

(require 'color-theme)
(load "color-theme-dml")
(load "color-theme-sore-eyes")
(color-theme-sore-eyes)

(add-to-list 'auto-mode-alist '("\\.feature$" . feature-mode))
(require 'cucumber-mode)

(load "rinari")

(require 'js2-mode)
(require 'shell-toggle)
(require 'fuzzy-match)
(require 'linum)
;; (require 'autopair)
;; (autopair-global-mode) ;; enable autopair in all buffers

(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))
(require 'actionscript-mode)


;; when the carrot doesn't work, it's time for some stick:
(when (featurep 'tabbar)
  (tabbar-mode nil))
(scroll-bar-mode nil)

;;----------------------------------------------------------------------------
;; Functions
;;----------------------------------------------------------------------------

(defun kill-unmodified-buffers ()
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
 aquamacs-autoface-mode nil            ; use default font everywhere
 viper-mode nil
 auto-insert-mode nil                  ; templates for new files
 auto-fill-mode nil                    ; turn off auto-fill by default
 c-default-style "k&r"                 ;
 c-basic-indent 2
 c-basic-offset 2        ; js2-mode uses this for JS indentation level
 column-number-mode 1
 dabbrev-abbrev-skip-leading-regexp "^:"
 dabbrev-case-fold-search nil
 dabbrev-case-replace nil
 case-fold-search t                     ; case-insensitive search
 comment-auto-fill-only-comments t
 debug-on-error nil                     ; NO! stop interrupting me
 debug-on-signal nil
 javascript-indent-level 2
 delete-by-moving-to-trash nil
 font-lock-mode t
 font-lock-maximum-decoration t         ; life is a colouring book
 frame-title-format "emacs - %b"        ; show buffer name in title
 global-font-lock-mode t
 indent-tabs-mode nil
 inhibit-splash-screen t                ; don't show the ugly buffalo
 interprogram-paste-function 'x-cut-buffer-or-selection-value
 ls-lisp-dirs-first t                   ; display dirs first in dired
 make-backup-files nil                  ; don't litter
 mark-even-if-inactive t
 menu-bar-mode nil
 org-startup-folded nil
 pc-select-meta-moves-sexps t
 pc-select-selection-keys-only t
 pc-selection-mode nil
 query-replace-highlight t             ; highlight all matches on page
 require-final-newline t               ; can't hurt, can help
 search-highlight t
 set-mark-command-repeat-pop t          ; C-u C-spc-spc-spc ...
 scroll-bar-mode nil
 show-paren-mode t
 show-trailing-whitespace t
 truncate-lines t                       ; nowrap
 tab-width 2
 transient-mark-mode nil
 tool-bar-mode nil
 tabbar-mode nil
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
 linum-format "%4d "
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
(setq ido-enable-flex-matching t)

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

; (setq org-tag-alist '((:startgroup . nil)
;                       ("@work" . ?w) ("@home" . ?h)
;                       ("@tennisclub" . ?t)
;                       (:endgroup . nil)
;                       ("laptop" . ?l) ("pc" . ?p)))


(setenv "EMACS" "t") ; so zsh, screen etc can depend on this

;;-----------------------------------------------------------------------------
;; Keybindings
;;-----------------------------------------------------------------------------

(if(featurep 'ns-toggle-fullscreen)
    (global-set-key (kbd "M-RET") 'ns-toggle-fullscreen))

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
(global-set-key (quote [C-right]) (quote forward-word))
(global-set-key (quote [C-left]) (quote backward-word))

(global-set-key (quote [M-right]) (quote forward-sexp))
(global-set-key (quote [M-left]) (quote backward-sexp))


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

;; Indentation help
(global-set-key (kbd "C-x ^") 'join-line)
(global-set-key (kbd "C-^") 'join-line)
(global-set-key (kbd "C-S-j") 'viper-join-lines)
(global-set-key (kbd "C-M-j") 'join-line)

;; rinari love
(global-set-key (kbd "M-]") 'rinari-find-file-in-project)

;; macros
;;
;; C-x C-k n (kmacro-name-last-macro)
;; M-x insert-kbd-macro
;; C-x C-k b (kmacro-bind-to-key)


;; TODO this should be in ruby-mode only
;; ' => '
(fset 'insert-right-arrow
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([32 61 62 33554464] 0 "%d")) arg)))

(global-set-key (kbd "C-c ;") 'insert-right-arrow)
(global-set-key (kbd "C-+") 'align-regexp)

;; (when (featurep 'aquamacs)
;; mac cheat keys - because context switching
;; Paste, Cut, Copy, Undo, Select-All
;; (global-set-key (kbd "M-v") (quote yank))
;;(global-set-key (kbd "M-x") (quote kill-region))
(global-set-key (kbd "M-c") (quote copy-region-as-kill))
;;(global-set-key (kbd "M-z") (quote undo))
;;(global-set-key (kbd "M-a") (quote mark-whole-buffer))
;;(global-set-key (kbd "M-s") 'save-buffer)
;; )

;; fix js2-mode indentation until it's factored into a minor mode:
;; http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode

(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 4
        indent-tabs-mode nil
        c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)]
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

