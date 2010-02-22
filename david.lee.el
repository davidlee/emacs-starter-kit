(message "Loading my own stuff")

;;----------------------------------------------------------------------------
;; Load Libraries
;;----------------------------------------------------------------------------
;;(require 'find-file-in-project)

(add-to-list 'load-path (concat dotfiles-dir "/custom"))
(add-to-list 'load-path (concat dotfiles-dir "/rinari"))
(add-to-list 'load-path (concat dotfiles-dir "/icicles"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor/tuareg-mode"))

(require 'flymake-jslint)
(add-hook 'javascript-mode-hook
          (lambda () (flymake-mode t)))
(add-hook 'js2-mode-hook
          (lambda () (flymake-mode t)))

;; TODO move to darwin-only config
(add-to-list 'load-path "/opt/local/lib/erlang/lib/tools-2.6.4/emacs")
(setq erlang-root-dir "/opt/local/lib/erlang")
(require 'erlang-start)

(ido-mode nil)
(require 'filecache)
(require 'icicles)
(icicle-mode)
(require 'rinari)
(require 'erlang)
(add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode))

;;(require 'anything)
;;(require 'proel)
;;(require 'git)

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

        ;; I like to indent case and labels to half of the tab width
        ;; (back-to-indentation)
        ;; (if (looking-at "case\\s-")
        ;;     (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 2 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 2)
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

;; END
;;
;;(setq cscope-do-not-update-database t
;;      grep-find-template "find .  -type f  -print0 | xargs -0 -e grep  -nH -e "
;;      anything-sources
;;        '(proel-anything-projects
;;          proel-anything-current-project-files))
;;
;;(require 'iswitchb)
;;(defun file-cache-iswitchb-file ()
;;  "Using iswitchb, interactively open file from file cache'.
;;First select a file, matched using iswitchb against the contents
;;in `file-cache-alist'. If the file exist in more than one
;;directory, select directory. Lastly the file is opened."
;;  (interactive)
;;  (let* ((file (file-cache-iswitchb-read "File: "
;;                                   (mapcar
;;                                    (lambda (x)
;;                                      (car x))
;;                                    file-cache-alist)))
;;         (record (assoc file file-cache-alist)))
;;    (find-file
;;     (concat
;;      (if (= (length record) 2)
;;          (car (cdr record))
;;        (file-cache-iswitchb-read
;;         (format "Find %s in dir: " file) (cdr record))) file))))
;;
;;(defun file-cache-iswitchb-read (prompt choices)
;;  (let ((iswitchb-make-buflist-hook
;;	 (lambda ()
;;	   (setq iswitchb-temp-buflist choices))))
;;    (iswitchb-read-buffer prompt)))
;;
;;(global-set-key "\C-cf" 'file-cache-iswitchb-file)
;;
;;;;(defun rails-add-proj-to-file-cache (dir)
;;;;  "Adds all the ruby and rhtml files recursiely in the current directory to the file-cache"
;;;;  (interactive "DAdd directory: ")
;;;;    (file-cache-clear-cache)
;;;;    (file-cache-add-directory-recursively dir (regexp-opt (list ".rb" ".rhtml" ".xml" ".js" ".yml" ".haml" ".css" ".rake" "Rakefile")))
;;;;    (file-cache-delete-file-regexp "\\.svn"))

;; (setq rinari-project-subdirs
;;       '("app" "lib" "config" "test" "public/javascripts" "public/stylesheets" "vendor"))
;; (defun project-files (&optional file)
;;   (when (or (not (boundp 'project-files-table))
;;             (not project-files-table) ; initial load
;; 	    (not (string-match
;;                   (expand-file-name (rails-root))
;;                   (cdar project-files-table)))) ; switched projects
;;     (setq project-files-table nil)
;;     (mapc 'populate-project-files-table
;;           (if file
;;               (list file)
;;             (mapcar (lambda (d) (concat (rails-root) "/" d)) rinari-project-subdirs))))
;;   project-files-table)
;;
;; (defadvice populate-project-files-table
;;   (around populate-project-files-table-ignoring-backups activate)
;;   "Ignore backup files."
;;   (if (file-directory-p file)
;;       (mapc 'populate-project-files-table (directory-files file t "^[^\.#].*[^~]$"))
;;     ad-do-it))
;;
;; (global-set-key "\C-x\C-\M-F" 'find-file-in-project)
;;
;; (add-hook ‘ruby-mode-hook (lambda (setl ffip-patterns “.*\\.rb”)))
