
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;; (add-to-list 'load-path "<path where use-package is installed>")
  (setq use-package-enable-imenu-support t)
  (require 'use-package))
;; to always use ensure
 ;; (setq use-package-always-ensure t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variables
(defvar ROOT (if (eq system-type 'darwin)
		 "~/OneDrive"
	       "~/Dropbox") "Root of shared files")
(defvar org-directory (concat ROOT "/org") "org dir")
(defvar org-journal-dir (concat ROOT "/org/journal") "org journal dir")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basics
(use-package emacs
  :init
  ;; Some functionality uses this to identify you, e.g. GPG configuration, email
  ;; clients, file templates and snippets. It is optional.
  (setq user-full-name "Chris Wallace"
	user-mail-address "cew54@cam.ac.uk"
	;; This determines the style of line numbers in effect. If set to `nil', line
	;; numbers are disabled. For relative line numbers, set this to `relative'.
	display-line-numbers-type t)
  ;;  Allow me to load files that are named in the current buffer
  (autoload 'find-file-at-point "ffap" nil t)
  (server-start)
  (defalias 'yes-or-no-p 'y-or-n-p) ;; life is too short
  (tool-bar-mode -1) ;; disables toolbar
  (scroll-bar-mode -1) ;; disables toolbar
  (display-time);; Display the time on the status bar
  (show-paren-mode t)
  (recentf-mode 1)
  ;; highlights FIXME: TODO: and BUG: in prog-mode
  ;; (add-hook 'prog-mode-hook
  ;; 	    (lambda ()
  ;; 	      (font-lock-add-keywords nil
  ;; 				      '(("\\<\\(HERE\\|FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))
  ;; (add-to-list 'imenu-generic-expression
  ;; 	       '("Packages"
  ;; 		 "\\(^\\s-*(use-package +\\)\\(\\_<.+\\_>\\)" 2))
  (global-set-key [f2] #'start-kbd-macro)
  (global-set-key [f3] #'end-kbd-macro)
  (global-set-key [f4] #'call-last-kbd-macro)
  (global-set-key [f5] #'kill-this-buffer)
  (global-set-key [M-f5] #'revert-buffer)
  (global-set-key [f6] #'query-replace)
  (global-set-key [f7] #'comment-region)
  (global-set-key [M-f7] #'uncomment-region)
  (global-set-key [f8] #'align)
  )

;; generate mouse-2 events by pressing Command when clicking with the trackpad.
(if (eq system-type 'darwin)
(define-key key-translation-map (kbd "<s-mouse-1>") (kbd "<mouse-2>")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; appearance
(setq custom-theme-load-path
      '(custom-theme-directory t "~/.emacs.d/emacs-color-theme-solarized"))
(load-theme 'solarized t)
;; (load-theme 'modus-vivendi)
(setq-default line-spacing 0.25
	      line-height 1.25)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NOTE: We need to load general before evil, otherwise the :general keyword in the use-package blocks won't work.
;; copying keys from https://github.com/doomemacs/doomemacs/blob/master/modules/config/default/+evil-bindings.el
;; copying code from https://github.com/doomemacs/doomemacs/blob/master/modules/config/default/+evil-bindings.el
(use-package general
  :config
  (general-evil-setup)
  (general-auto-unbind-keys)
  ;; set up 'SPC' as the global leader key
  (general-create-definer cw/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :non-normal-prefix "M-SPC")
  ;; set up ',' as the local leader key
  (general-create-definer cw/local-leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "," ;; set local leader
    :non-normal-prefix "M-,") ;; access local leader in insert mode

  ;; unbind some annoying default bindings
  (general-unbind
    "C-x C-r"   ;; unbind find file read only
    "C-x C-z"   ;; unbind suspend frame
    "C-x C-d")   ;; unbind list directory

  (cw/leader-keys
    "SPC" '(execute-extended-command :wk "execute command") ;; an alternative to 'M-x'
    "M-SPC" '(execute-extended-command :wk "execute command") ;; an alternative to 'M-x'
    "TAB" '(:keymap tab-prefix-map :wk "tab") ;; remap tab bindings
    ";" '(eval-expression :which-key "eval sexp"))

  (cw/leader-keys
    "c" '(:ignore t :wk "code"))

  ;; help
  ;; namespace mostly used by 'helpful'
  (cw/leader-keys
    "h" '(:ignore t :wk "help")
    "he" 'view-echo-area-messages
    "hf" 'describe-function
    "hF" 'describe-face
    "hl" 'view-lossage
    "hL" 'find-library
    "hm" 'describe-mode
    "hk" 'describe-key
    "hK" 'describe-keymap
    "hp" 'describe-package
    "hv" 'describe-variable)

  ;; file
  (cw/leader-keys
    "f" '(:ignore t :wk "file")
    "fd" #'deft
    "ff" '(find-file-at-point :wk "ffap")
    "fr" #'recentf-open-files
    "fo" '((lambda () (interactive) (find-file org-directory)) :wk orgdir)
    "f4" '((lambda () (interactive) (find-file (concat org-directory "/42.org"))) :wk "42.org")
    "fP" '((lambda () (interactive) (find-file "~/.emacs.d/init.el")) :wk "emacs-config")
    "fs" #'save-buffer
    "fw" #'write-file
    )

  ;; buffers
  (cw/leader-keys
    "b" '(:ignore t :wk "buffer")
    "bb" #'switch-to-buffer)
  
  ;; bookmark
  (cw/leader-keys
    "B" '(:ignore t :wk "bookmark")
    "Bs" '(bookmark-set :wk "set bookmark")
    "Bj" '(bookmark-jump :wk "jump to bookmark"))

  (cw/leader-keys
    "i" '(:ignore t :wk "insert")
    "iy" #'consult-yank-pop
    "i*" #'org-toggle-heading)
  
  ;; universal argument
  (cw/leader-keys
    "u" '(universal-argument :wk "universal prefix"))

  ;; notes - see 'org'
  (cw/leader-keys
    "n" '(:ignore t :wk "notes")
    "na" #'org-agenda
    "nd" #'deft
    "nj" #'org-journal-new-entry
    "nl" #'org-store-link
    "nL" #'org-insert-link
    "nm" #'org-tags-view
    "nn" #'org-capture
    ;; "ns" #'org-journal-search ;; this will prompt for a date range
    "ns" '(lambda () (interactive)
                  (let ((current-prefix-arg '(4))) ; C-u
                  (call-interactively 'org-journal-search))) ;; this will search all journal files
    "nt" #'org-todo-list) ;; agenda

  ;; search
  ;; see 'consult'
  (cw/leader-keys
    "s" '(:ignore t :wk "search")'
    "si" #'consult-imenu
    "sL" '(ffap-menu :wk "Jump to link")
    "sj" '(evil-show-jumps :wk "Jump list")
    "sB" '(bookmark-jump :wk "Jump to bookmark")
    "sm" '(evil-show-marks :wk "Jump to mark")
    ))

;; evil-mode
(setq evil-want-C-i-jump nil) ; emacs TAB wins
(use-package evil
  :general
  (general-nmap ; default is global
    "<" #'backward-page
    ">" #'forward-page)
    :init
    (setq evil-undo-system 'undo-redo)
  
  :config
  (progn
    (evil-mode 1)
    
    ;; iESS just doesn't work in evil mode, don't understand why
    (add-to-list 'evil-emacs-state-modes 'inferior-ess-r-mode)
    ;; dired has too many good bindings to change for evil
    (add-to-list 'evil-emacs-state-modes 'dired-mode)
    (add-to-list 'evil-emacs-state-modes 'easy-jekyll-mode)

    ;; Make movement keys work respect visual lines
    (defun evil-next-line--check-visual-line-mode (orig-fun &rest args)
      (if visual-line-mode
	  (apply 'evil-next-visual-line args)
	(apply orig-fun args)))
    (advice-add 'evil-next-line :around 'evil-next-line--check-visual-line-mode)
    (defun evil-previous-line--check-visual-line-mode (orig-fun &rest args)
      (if visual-line-mode
	  (apply 'evil-previous-visual-line args)
	(apply orig-fun args)))
    (advice-add 'evil-previous-line :around 'evil-previous-line--check-visual-line-mode)
    ;; Make horizontal movement cross lines
    (setq-default evil-cross-lines t
		  evil-move-cursor-back nil ; don#t jump back after existing insert
		  evil-want-C-w-delete nil) 
    ;; (defalias #'forward-evil-word #'forward-evil-symbol)
    ;; don't  use vim search
    ;; (evil-select-search-module 'evil-search-module 'isearch)
    (evil-select-search-module 'evil-search-module 'evil-search)
    ;; (with-eval-after-load 'evil-maps
    (define-key evil-insert-state-map (kbd "RET") 'newline-and-indent)

    ;; keys
    (setq evil-want-fine-undo t);; fine undo like I'm used to in emacs please
    (define-key evil-motion-state-map ";" 'smex)
    (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
    (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
    (define-key evil-insert-state-map (kbd "ESC") 'normal-mode)
    ;; (define-key evil-motion-state-map (kbd "TAB") 'indent-for-tab-command)
    ;; (define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)
    (define-key evil-normal-state-map [escape] 'keyboard-quit)
    (evil-define-key 'insert global-map (kbd "C-j") 'evil-next-line)
    (evil-define-key 'insert global-map (kbd "C-k") 'evil-previous-line)
    ;; (evil-define-key 'insert global-map (kbd "C-l") 'evil-forward-char)
    ;; (evil-define-key 'insert global-map (kbd "C-h") 'evil-backward-char)
    
    (add-hook 'text-mode-hook 'turn-on-visual-line-mode)
    ;; but retain C-k killing as normal
    ;; http://emacs.stackexchange.com/questions/13279/ctrl-k-kill-line-not-screen-edge-in-visual-line-mode
    (define-key visual-line-mode-map [remap kill-line] nil)
    ;; Treat wrapped line scrolling as single lines
    (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
    ;; (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
    (define-key evil-normal-state-map  "zz" 'evil-toggle-fold)
    (defun evil-select-last-yanked-text ()
      "uses evils markers to select the last yanked text"
      (interactive)
      (evil-goto-mark ?\[)
      (evil-visual-char)
      (evil-goto-mark ?\]))
    (define-key evil-normal-state-map (kbd "gp") 'evil-select-last-yanked-text)
    (define-key evil-normal-state-map "\C-y" 'yank)
    (define-key evil-insert-state-map "\C-y" 'yank)
    (define-key evil-visual-state-map "\C-y" 'yank)
    (define-key evil-insert-state-map "\C-e" 'end-of-line)
    (define-key evil-normal-state-map "\C-w" 'evil-delete)
    (define-key evil-insert-state-map "\C-w" 'evil-delete)
    (define-key evil-insert-state-map "\C-r" 'search-backward)
    (define-key evil-visual-state-map "\C-w" 'evil-delete)
    ;;instead of joining lines, insert a new line at point
    (defun disJoin () "Inverse of evil-join"
	   (interactive)
	   (insert "\n")
	   (forward-line -1)
	   (evil-move-end-of-line))
    (define-key evil-normal-state-map "K" 'disJoin)
    (setq evil-want-fine-undo t
	  evil-cross-lines t)))

(use-package vimish-fold
  :after evil)

(use-package evil-vimish-fold
  :after vimish-fold
  :init
  (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
  :config
  (global-evil-vimish-fold-mode))

(use-package evil-matchit
  :init 
  (global-evil-matchit-mode 1))

;; (use-package evil-snipe
;;   :init
;;   (evil-snipe-mode +1)
;;   (evil-snipe-override-mode +1)
;;   (setq evil-snipe-scope 'buffer
;; 	evil-snipe-repeat-scope 'buffer
;; 	evil-snipe-spillover-scope 'whole-buffer))

;; evil-numbers
;; (load "/home/chris/genconfig/evil-numbers.el")
;; (define-key evil-normal-state-map (kbd "g +") 'evil-numbers/inc-at-pt)
;; (define-key evil-normal-state-map (kbd "g -") 'evil-numbers/dec-at-pt)
;; (define-key evil-normal-state-map (kbd " C-+") 'evil-numbers/inc-at-pt-incremental)
;; (define-key evil-normal-state-map (kbd " C--") 'evil-numbers/dec-at-pt-incremental)

;; evil-mc
;; (require 'evil-mc)
;; (evil-define-key 'visual evil-mc-key-map
;;   "A" #'evil-mc-make-cursor-in-visual-selection-end
;;   "I" #'evil-mc-make-cursor-in-visual-selection-beg)

(use-package which-key
  :after evil
  :init (which-key-mode)
  :config
  (which-key-setup-minibuffer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Example configuration for Consult
(use-package consult
  
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :general
  (general-nmap
    :states '(normal insert)
    "C-p" 'consult-yank-pop)
  (cw/leader-keys
    "s i" '(consult-imenu :wk "imenu")
    "s I" '(consult-imenu-multi :wk "imenu")
    "s o" '(consult-outline :which-key "outline")
    "s s" 'consult-line
    "s f" 'consult-recent-file
    "f r" 'consult-recent-file
    "s p" '(consult-ripgrep :wk "ripgrep project")
    "b b" 'consult-buffer
    ;; TODO consult mark
    ;; "f r" 'consult-recent-file
    ;; "s !" '(consult-flymake :wk "flymake")
    "s h" 'consult-history
    "s b" 'consult-buffer                ;; orig. switch-to-buffer
    "sy" #'consult-yank-pop               ;; orig. yank-pop
    "s o" #'consult-outline               ;; Alternative: consult-org-heading
    "s l" #'consult-line
    "s L" #'consult-line-multi)

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init
  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config
  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key (kbd "M-.")
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  )

(use-package vertico           ; the search engine of the future
  :init
  (vertico-mode))



(use-package page-break-lines
  :init
  ;; (add-to-list 'page-break-lines-modes 'ess-r-mode)
  ;; (add-to-list 'page-break-lines-modes 'ruby-mode)
  (global-page-break-lines-mode))

(use-package hl-todo
  :load-path "~/.emacs.d/lisp"
  :hook (prog-mode . hl-todo-mode)
  :hook (yaml-mode . hl-todo-mode)
  :config
   (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(;; For reminders to change or add something at a later date.
          ("TODO" warning bold)
          ;; For code (or code paths) that are broken, unimplemented, or slow,
          ;; and may become bigger problems later.
          ("FIXME" error bold)
          ;; For code that needs to be revisited later, either to upstream it,
          ;; improve it, or address non-critical issues.
          ("REVIEW" font-lock-keyword-face bold)
          ;; For code smells where questionable practices are used
          ;; intentionally, and/or is likely to break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For sections of code that just gotta go, and will be gone soon.
          ;; Specifically, this means the code is deprecated, not necessarily
          ;; the feature it enables.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; Extra keywords commonly found in the wild, whose meaning may vary
          ;; from project to project.
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))


(use-package mood-line
  :config (mood-line-mode))

(require 'yafolding)
(add-hook 'ruby-mode-hook 'yafolding-mode)
(global-set-key [f1]   'yafolding-toggle-element)
(global-set-key [S-f1]   'yafolding-toggle-all)

;; (add-hook 'ruby-mode-hook
;;           (lambda () (hs-minor-mode)))
;; (eval-after-load "hideshow"
;;   '(add-to-list 'hs-special-modes-alist
;;               `(ruby-mode
;;                 ,(rx (or "def" "class" "module" "do" "{" "[" "if" "else" "unless")) ; Block start
;;                 ,(rx (or "}" "]" "end"))                       ; Block end
;;                 ,(rx (or "#" "=begin"))                        ; Comment start
;;                 ruby-forward-sexp nil)))
;; (global-set-key [f1] #'hs-toggle-hiding)
;; (global-set-key [S-f1] #'hs-hide-all)

;; (use-package origami
;;   :config
;;   (global-set-key [f1] #'origami-toggle-node)
;;   (global-set-key [M-f1] #'origami-toggle-all-nodes)
;;   )

(use-package helpful
  :general
  (cw/leader-keys
    "hc" '(helpful-command :wk "helpful command")
    "hf" '(helpful-callable :wk "helpful callable")
    "hh" '(helpful-at-point :wk "helpful at point")
    "hF" '(helpful-function :wk "helpful function")
    "hv" '(helpful-variable :wk "helpful variable")
    "hk" '(helpful-key :wk "helpful key")))
;; fix x selection - but at a cost of making everything slow
;; (advice-remove #'evil-visual-update-x-selection #'ignore)

;; (setq-hook! 'ess-r-mode-hook
;; 	    ;; HACK Fix #2233: Doom continues comments on RET, but ess-r-mode doesn't
;; 	    ;;      have a sane `comment-line-break-function', so...
;; 	    comment-line-break-function nil)

(use-package evil-commentary
  :init
  (evil-commentary-mode))


;; handy
;; bubble lines
;; Line Bubble Functions
(defun move-line-up ()
  "move the current line up one line"
  (interactive)
  (transpose-lines 1)
  (previous-line 2))
(defun move-line-down ()
  "move the current line down one line"
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))
(defun evil-move-lines (direction)
  "move selected lines up or down"
  (interactive)
  (evil-delete (region-beginning) (region-end))
  (evil-normal-state)
  (if (equal direction "up")
      (evil-previous-line)
    (evil-next-line))
  (evil-move-beginning-of-line)
  (evil-paste-before 1)
  (evil-visual-line (point) (- (point) (- (region-end) (region-beginning)))))
(defun evil-move-lines-up ()
  "move selected lines up one line"
  (interactive)
  (evil-move-lines "up"))
(defun evil-move-lines-down ()
  "move selected lines down one line"
  (interactive)
  (evil-move-lines "down"))
(define-key evil-normal-state-map (kbd "C-k") 'move-line-up)
(define-key evil-normal-state-map (kbd "C-j") 'move-line-down)
(define-key evil-visual-state-map (kbd "C-k") 'evil-move-lines-up)
(define-key evil-visual-state-map (kbd "C-j") 'evil-move-lines-down)
(define-key evil-normal-state-map (kbd "<down>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<up>")   'evil-previous-visual-line)
;; Also in visual mode
(define-key evil-visual-state-map (kbd "<down>") 'evil-next-visual-line)
(define-key evil-visual-state-map (kbd "<up>")   'evil-previous-visual-line)

(evil-define-key 'insert global-map (kbd "M-/") 'hippie-expand)



;; convenience settings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fset 'yes-or-no-p 'y-or-n-p)    ; y-or-n instead of yes-or-no
(setq next-line-add-newlines nil ; no blank lines and end of buffer
      scroll-step 3              ; scroll-step
      require-final-newline t    ; Always end a file with a newline
      max-specpdl-size 4800      ; increase the number of lisp variable bindings we can have. Default 600.
      max-lisp-eval-depth 1600   ; increase our effective stack depth for evaluations.  Default 200.
      font-lock-maximum-decoration t
      display-time-24hr-format nil
      dired-no-confirm           ; Stop asking for confirmation in dired
      '(byte-compile chgrp chmod chown compress copy delete hardlink load move
                     print shell symlink uncompress)
      completion-ignored-extensions    ;;  Ignore when completing filenames
      (list ".4LG" ".BAK" ".WRD" ".aux" ".bbl" ".blg" "toc" ".dvi" ".exe"
            ".log" ".pdf" ".ps" "~" ".xls")
      )
;;  Allow normally disabled functions to be enabled.
(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; from https://www.reddit.com/r/emacs/comments/nf2k5y/comment/i5pxbc9/
;; might make project.el more usable
;; I only really use git, stamp on vc-mode....
(with-eval-after-load 'vc
  (remove-hook 'find-file-hook 'vc-find-file-hook)
  (remove-hook 'find-file-hook 'vc-refresh-state)
  (setq vc-handled-backends nil))
;; smart parens
;; (require 'smartparens-config)
;; (smartparens-mode)
;; (electric-pair-mode)

;; * MakingScriptsExecutableOnSave
;; Check for shebang magic in file after save, make executable if found.
(setq my-shebang-patterns
      (list "^#!/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
            "^#!/usr/.*/sh"
            "^#!/usr/.*/bash"
            "^#!/usr/bin/Rscript"
            "^#!/bin/sh"
            "^#!/bin/bash"))
(add-hook
 'after-save-hook
 (lambda ()
   (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
       (progn
         ;; This puts message in *Message* twice, but minibuffer
         ;; output looks better.
         (message (concat "Wrote " (buffer-file-name)))
         (save-excursion
           (goto-char (point-min))
           ;; Always checks every pattern even after
           ;; match.  Inefficient but easy.
           (dolist (my-shebang-pat my-shebang-patterns)
             (if (looking-at my-shebang-pat)
                 (if (= (shell-command
                         (concat "chmod u+x " (buffer-file-name)))
                        0)
                     (message (concat
                               "Wrote and made executable "
                               (buffer-file-name))))))))
     ;; This puts message in *Message* twice, but minibuffer output
     ;; looks better.
     (message (concat "Wrote " (buffer-file-name))))))
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;  A small calculator mode
(autoload 'calculator "calculator" "A simple calculator" t)
(global-set-key "\C-xc" 'calculator)
                                        ;(load "wc") ;; count words

;; Buffer selection code.
;; I want to see all buffers, not just those attatched to a file.
;; I want to see those buffers at the end of the display
(require 'bs)
(setq bs-default-configuration "all")
(setq bs-buffer-sort-function 'bs-sort-buffer-interns-are-last)

;; from http://emacs.stackexchange.com/questions/17984/how-to-change-mode-line-color-based-on-host
(defvar my-remote-buffer-colors
  (let ((colors '(("red" "darkred")
                  ("green" "darkgreen")
                  ("blue" "darkblue")
                  ("orange" "firebrick"))))
    (setcdr (last colors) colors)
    colors)
  "Cyclic list of color combos to use for remote files.
Elements are in the form: (active-background-color inactive-background-color).")

(defvar my-assigned-remote-colors (make-hash-table :test 'equal)
  "Hash table pairing remote hosts to mode-line color overrides.")

(defvar-local my-assigned-remote-color-cookies nil
  "Stores the face remap cookies created by `my-maybe-assign-remote-color' for removal if necessary.")

(defun my-maybe-assign-remote-color ()
  "If newly found file is remote assign it new modeline colors.

Colors are taken from `my-remote-buffer-colors', every file on the same remote
host will have the same colors, each newly accessed remote host will be assigned a new
color cycled from `my-remote-buffer-colors'."
  (let ((remote (file-remote-p default-directory)))
    (when remote
      (let ((color (or (gethash remote my-assigned-remote-colors)
                       (puthash remote (pop my-remote-buffer-colors) my-assigned-remote-colors))))
        (setq my-assigned-remote-color-cookies
              (list (face-remap-add-relative 'mode-line (list :background (car color)))
                    (face-remap-add-relative 'mode-line-inactive (list :background (cadr color)))))))))

(add-hook 'find-file-hook 'my-maybe-assign-remote-color)
(add-hook 'dired-mode-hook 'my-maybe-assign-remote-color)

;; turn off bell - makes using the wheel very noisy...
(setq ring-bell-function (lambda()))
(global-hl-line-mode 1)

;; limit undo memory
(setq undo-outer-limit 10000000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; org-mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :config
  (require 'org-tempo) ; allow <q, <c etc
  (defun cw/org-journal-find-location ()
    ;; Open today's journal, but specify a non-nil prefix argument in order to
    ;; inhibit inserting the heading; org-capture will insert the heading.
    (org-journal-new-entry t)
    (unless (eq org-journal-file-type 'daily)
      (org-narrow-to-subtree))
    (goto-char (point-max)))
  (add-to-list 'org-file-apps '("\\.docx\\'" . "open %s"))
  (add-to-list 'org-file-apps '("\\.pptx\\'" . "open %s"))
  (setq org-refile-file (format "%s/refile.org" org-directory)
	;; level 1 files, that I might refile to
	cw/org-files1 (apply #'append `((,(concat org-directory "/habits.org"))
					,(file-expand-wildcards (concat org-directory "/Collab/[a-zA-Z0-9]*.org"))
					,(file-expand-wildcards (concat org-directory "/Admin/[a-zA-Z0-9]*.org"))
					,(file-expand-wildcards (concat org-directory "/Projects/[a-zA-Z0-9]*.org"))))
	;; journal files - for the agenda but not refile targets - current and previous year
	cw/org-files2 (apply #'append `(,(file-expand-wildcards (concat org-journal-dir "/2022*.org"))
					,(file-expand-wildcards (concat org-journal-dir "/2023*.org"))))
	;; agenda
	org-agenda-files (append cw/org-files1 cw/org-files2)
	org-agenda-sorting-strategy '(deadline-up)
	org-agenda-start-with-follow-mode t
	org-agenda-todo-ignore-scheduled 14
	org-agenda-custom-commands
	'(("t" "List of all TODO entries" alltodo ""
	   ((org-agenda-view-columns-initially t)))
	  ("n" "Agenda and TODOs" ((agenda "") (alltodo ""))))
	;; refile
	org-refile-allow-creating-parent-nodes 'confirm
	org-refile-targets '((nil :maxlevel . 2)
			     (cw/org-files1 :maxlevel . 2)
			     (cw/org-files2 :maxlevel . 2))
	;; other
	org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
	org-columns-default-format "%60ITEM %TODO %3PRIORITY %12TAGS %DEADLINE"
	;; org-refile-targets (list (org-agenda-files :maxlevel 3))
	org-capture-templates '(("j" "Journal entry" plain (function cw/org-journal-find-location)
				 "** %(format-time-string org-journal-time-format)%i %? %^G"
				 :jump-to-captured t
				 :immediate-finish t)
				("t" "Todo" plain (function cw/org-journal-find-location)
				 "** TODO %(format-time-string org-journal-time-format)%i %? %^G"
				 :jump-to-captured t :immediate-finish t)
				("n" "Note" entry (file (format "%s/refile.org" org-directory))
				 "** NOTE  %? %(format-time-string org-journal-time-format)")
				;; from https://www.mediaonfire.com/blog/2017_07_21_org_protocol_firefox.html
				;; ("w" "org-protocol" entry (file "~/Dropbox/org/refile.org")
				("w" "org-protocol" entry (file org-refile-file)
				 "* TODO Review %a\n%U\n%:initial\n"
				 :jump-to-captured t :immediate-finish t)
				))
  (cw/local-leader-keys
    :keymaps 'org-mode-map
    "a" '(org-archive-subtree :wk "archive")
    ;; "l" '(:ignore t :wk "link")
    "l" '(org-insert-link t :wk "link")
    "L" '(org-mac-link-get-link t :wk "link to a mac file")
    ;; "lp" '(org-latex-preview t :wk "prev latex")
    "h" '(consult-org-heading :wk "consult heading")
    "d" '(org-cut-special :wk "org cut special")
    "y" '(org-copy-special :wk "org copy special")
    "p" '(org-paste-special :wk "org paste special")
    "t" '(org-todo :wk "todo")
    "s" '(org-insert-structure-template :wk "template")
    "e" '(org-edit-special :wk "edit")
    "i" '(:ignore t :wk "insert")
    "ih" '(org-insert-heading :wk "insert heading")
    "is" '(org-insert-subheading :wk "insert heading")
    "f" '(org-footnote-action :wk "footnote action")
    ">" '(org-demote-subtree :wk "demote subtree")
    "<" '(org-promote-subtree :wk "demote subtree"))
  :general
  (:keymaps 'org-agenda-mode-map :states 'motion
	    "+" #'org-capture
	    "j" #'org-agenda-next-line
	    "h" #'org-agenda-previous-line)
  :general
  (general-define-key
   :states 'insert
   :map 'org-mode-map
   "M-<return>" #'org-insert-item))

(use-package org-mac-link)

;; (use-package evil-org
;;   :ensure t)th
;; (general-define-key ; :after evil-org
;;  :states '(normal insert)
;;       "C-c c" #'org-capture
;;       :map evil-org-mode-map
;;       "C-S-<return>" #'org-insert-heading-respect-content)
;; (use-package org-agenda
;;   :ensure t)
(use-package org-journal
  :after org
  :init
  (setq org-journal-dir (format "%s/journal/" org-directory)
	org-journal-file-type 'monthly
	org-journal-file-format "%Y%m.org"
	org-journal-date-format "%A, %d/%m/%y"
	org-journal-time-format "%d/%m"
	org-journal-carryover-items 'nil))

(use-package deft
  :config
  (setq deft-extensions '("org")
	deft-directory org-directory
	deft-recursive t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc"))

(use-package cdlatex)

(use-package latex
  :ensure auctex
    :mode
    ("\\.tex\\'" . latex-mode)
    :bind
    (:map LaTeX-mode-map
          ("M-<delete>" . TeX-remove-macro)
          ("C-c C-r" . reftex-query-replace-document)
          ("C-c C-g" . reftex-grep-document))
    :init
    ;; A function to delete the current macro in AUCTeX.
    ;; Note: keybinds won't be added to TeX-mode-hook if not kept at the end of the AUCTeX setup!
    (defun TeX-remove-macro ()
        "Remove current macro and return TRUE, If no macro at point, return Nil."
        (interactive)
        (when (TeX-current-macro)
            (let ((bounds (TeX-find-macro-boundaries))
                  (brace  (save-excursion
                              (goto-char (1- (TeX-find-macro-end)))
                              (TeX-find-opening-brace))))
                (delete-region (1- (cdr bounds)) (cdr bounds))
                (delete-region (car bounds) (1+ brace)))
            t))
    (add-hook 'LaTeX-mode-hook #'LaTeX-math-mode)
    :config
    (setq-default TeX-master t ; by each new fie AUCTEX will ask for a master fie.
                  TeX-PDF-mode t
                  TeX-engine 'xetex)     ; optional
    (setq TeX-auto-save t
          TeX-save-query nil       ; don't prompt for saving the .tex file
          TeX-parse-self t
          TeX-show-compilation nil         ; if `t`, automatically shows compilation log
          LaTeX-babel-hyphen nil ; Disable language-specific hyphen insertion.
          ;; `"` expands into csquotes macros (for this to work, babel pkg must be loaded after csquotes pkg).
          LaTeX-csquotes-close-quote "}"
          LaTeX-csquotes-open-quote "\\enquote{"
          TeX-file-extensions '("Rnw" "rnw" "Snw" "snw" "tex" "sty" "cls" "ltx" "texi" "texinfo" "dtx"))

    ;; Font-lock for AuCTeX
    ;; Note: '«' and '»' is by pressing 'C-x 8 <' and 'C-x 8 >', respectively
    (font-lock-add-keywords 'latex-mode (list (list "\\(«\\(.+?\\|\n\\)\\)\\(+?\\)\\(»\\)" '(1 'font-latex-string-face t) '(2 'font-latex-string-face t) '(3 'font-latex-string-face t))))
    ;; Add standard Sweave file extensions to the list of files recognized  by AuCTeX.
    (add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)
    (add-hook 'TeX-mode-hook (lambda () (reftex-isearch-minor-mode))))


(use-package key-chord)
;; emacs speaks statistics, tramp
(use-package ess
  :config
  (general-def
    :states '(normal insert)
    :keymaps 'ess-mode-map
    [C-return] #'ess-eval-line-and-step
    "," #'nil)
  (general-def
    :states '(normal visual)
    :prefix ","
    "," #'ess-eval-region-or-function-or-paragraph-and-step
    "s" #'ess-switch-process
    "f" #'ess-eval-function-or-paragraph
    "r" #'ess-eval-region-)
  (general-def
    :states '(emacs)
    [up]  'comint-previous-matching-input-from-input
    [down]  'comint-next-matching-input-from-input)
;; ess-roxy-update-entry
(setq ess-roxy-template-alist '(("description" . " content for description")
                            ("details" . "content for details")
                            ("title" . "")
                            ("param" . "")
                            ("return" . "")
                            ("export" . "")
                            ("author" . "Chris Wallace")))
  ;; Open Rdired buffer with F9:
  (add-hook 'ess-r-mode-hook
	    '(lambda ()
	       (local-set-key (kbd "<f9>") #'ess-rdired)))
  ;; Close Rdired buffer with F9 as well:
  (add-hook 'ess-rdired-mode-hook
	    '(lambda ()
	       (local-set-key (kbd "<f9>") #'kill-buffer-and-window)))
(add-to-list 'display-buffer-alist
	       `("*R"
		 (display-buffer-reuse-window display-buffer-in-side-window)
		 (side . left)
		 (slot . -1)
		 (window-width . 0.5)
		 (reusable-frames . 0)))
  (add-hook 'ess-r-mode-hook (lambda ()
			       (key-chord-mode 1)
			       (key-chord-define evil-insert-state-map ">>" (lambda () (interactive) (insert " %>% ")))
			       (key-chord-define evil-insert-state-map "<>" (lambda () (interactive) (insert " %<>% ")))
			       (key-chord-define evil-insert-state-map "`r"
						 (lambda ()
						   (interactive)
						   (insert "\n```{r}\n\n```\n")
						   (previous-line 2)))
			       ;; (key-chord-define-local ">>" (lambda () (interactive) (insert " %>% ")))
			       ;; (key-chord-define-local "<>" (lambda () (teractive) (insert " %<>% ")))
			       ;; (turn-on-orgstruct)
			       ;; (setq-local orgstruct-heading-prefix-regexp "## ")
			       (setq ess-eval-visibly-p 'nowait) ;; no waiting while ess evalating
			       (outline-minor-mode) ;  OUTSHINE-MODE
			       )))
(use-package tramp
  :config
  ;; Another way to find the remote path is to use the path assigned to the remote 
  ;; user by the remote host. TRAMP does not normally retain this remote path
  ;; after login. However, tramp-own-remote-path preserves the path value, which
  ;; can be used to update tramp-remote-path.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  ;; When TRAMP cleans a connection, it removes the respective remote file name(s) from recentf-list. This is needed, because an unresponsive remote host could trigger recentf to connect that host again and again.
  ;; If you find the cleanup disturbing, because the file names in recentf-list are precious to you, you could add the following two forms in your ~/.emacs after loading the tramp and recentf packages:
  (remove-hook 'tramp-cleanup-connection-hook #'tramp-recentf-cleanup)
  (remove-hook 'tramp-cleanup-all-connections-hook #'tramp-recentf-cleanup-all)
  ;; (remove-hook 'kill-emacs-hook #'recentf-cleanup) ;; doom adds this
  (setq
   ;; I tend to use magit anyway, but disable VC mode over TRAMP
   vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
				vc-ignore-dir-regexp
				tramp-file-name-regexp)
   tramp-password-prompt-regexp
   "^.*\\(\\(?:adgangskode\\|contrase\\(?:\\(?:ny\\|ñ\\)a\\)\\|TOTP Verification Code\\|decryption key\\|encryption key\\|geslo\\|h\\(?:\\(?:asł\\|esl\\)o\\)\\|iphasiwedi\\|jelszó\\|l\\(?:ozinka\\|ösenord\\)\\|m\\(?:ot de passe\\|ật khẩu\\)\\|p\\(?:a\\(?:rola\\|s\\(?:ahitza\\|s\\(?: phrase\\|code\\|ord\\|phrase\\|wor[dt]\\)\\|vorto\\)\\)\\|in\\)\\|s\\(?:alasana\\|enha\\|laptažodis\\)\\|wachtwoord\\|лозинка\\|пароль\\|ססמה\\|كلمة السر\\|गुप्तशब्द\\|शब्दकूट\\|গুপ্তশব্দ\\|পাসওয়ার্ড\\|ਪਾਸਵਰਡ\\|પાસવર્ડ\\|ପ୍ରବେଶ ସଙ୍କେତ\\|கடவுச்சொல்\\|సంకేతపదము\\|ಗುಪ್ತಪದ\\|അടയാളവാക്ക്\\|රහස්පදය\\|ពាក្យសម្ងាត់\\|パスワード\\|密[码碼]\\|암호\\)\\).*: ? *")
  ;; Auto-saves tramp files on our local file system
  (add-to-list 'backup-directory-alist
	       (cons tramp-file-name-regexp "~/.emacs.d/tramp-saves")))

(use-package
  sql-impala)

(use-package project
  :general
  ;; assign built-in project.el bindings a new prefix
  (cw/leader-keys "p" '(:keymap project-prefix-map :wk "project")))

(use-package evil-surround
  :ensure t
  :general
  (:states 'operator
	   "s" 'evil-surround-edit
	   ;; "S" 'evil-Surround-edit
	   )
  (:states 'visual
	   "s" 'evil-surround-region
	   ;; "S" 'evil-Surround-region
	   ))

;; https://github.com/karthink/project-x/
(use-package project-x
  :load-path "~/.emacs.d/lisp"
  :after project
  :config
  (setq project-x-save-interval 600)    ;Save project state every 10 min
  (setq project-x-local-identifier ".git")
  (project-x-mode 1))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; latex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq reftex-cite-format "\\cite{%l}"
      cdlatex-paired-parens "")

(use-package darkroom
  :config
  (require 'darkroom))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/Users/cw029707/OneDrive/org/journal/202212.org" "/Users/cw029707/OneDrive/org/journal/202301.org" "/Users/cw029707/OneDrive/org/journal/202302.org" "/Users/cw029707/OneDrive/org/journal/202303.org"))
 '(package-selected-packages
   '(cdlatex CDLaTeX auctex markdown-mode sql-impala darkroom darkroom-mode writeroom-mode writeroom olivetti origami page-break-lines orderless evil-surround helpful org which-key vertico use-package org-journal mood-line key-chord general evil-vimish-fold evil-snipe evil-org evil-matchit evil-commentary ess deft)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
