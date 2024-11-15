;;; init.el --- my Emacs init file -*- lexical-binding: t; -*-

;;; Commentary:

;; My Emacs init file.

;;; Code:

;; The value of this variable is the number of bytes of storage that must be
;; allocated for Lisp objects after one garbage collection in order to
;; trigger another garbage collection.
(setq gc-cons-threshold (* 800000 2))

(use-package emacs
  :ensure nil
  :custom                                         ;; Set custom variables to configure Emacs behavior.
  ;; Fido.
  (icomplete-mode t)
  (icomplete-separator "\n")
  (icomplete-hide-common-prefix nil)
  (icomplete-in-buffer t)
  (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-backward-completions)
  (fido-vertical-mode t)
  (dired-kill-when-opening-new-dired-buffer t)    ;; Reuse buffer.
  (history-length 25)                             ;; Set the length of the command history.
  (savehist-mode t)                               ;; Save minibuffer history.
  (undo-no-redo t)                                ;; Undo.
  (column-number-mode t)                          ;; Display the column number in the mode line.
  (auto-save-default nil)                         ;; Disable automatic saving of buffers.
  (create-lockfiles nil)                          ;; Prevent the creation of lock files when editing.
  (inhibit-startup-message t)                     ;; Disable the startup message when Emacs launches.
  (inhibit-startup-echo-area-message t)           ;; Disable the startup message in echo area.
  (make-backup-files nil)                         ;; Disable creation of backup files.
  (pixel-scroll-precision-mode t)                 ;; Enable precise pixel scrolling.
  (pixel-scroll-precision-use-momentum nil)       ;; Disable momentum scrolling for pixel precision.
  (ring-bell-function 'ignore)                    ;; Disable the audible bell.
  (warning-minimum-level :emergency)              ;; Set the minimum level of warnings to display.
  (use-short-answers t)                           ;; Use short answers in prompts for quicker responses (y instead of yes).
  (duplicate-line-final-position 1)               ;; Specifies where to move point after duplicating the line.
  (tags-revert-without-query t)                   ;; Don't prompt me to load tags.
  ;; Replace the standard text representation of various identifiers/symbols.
  (global-prettify-symbols-mode t)
  (gdb-many-windows 1)                            ;; gdb many windows layout.
  (gdb-show-main 1)                               ;; Showing the source for the main function of the program you are debugging.
  (scheme-program-name "guile3.0")                ;; Set guile default scheme.
  
  ;; ANSI Coloring in Compilation Mode.
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

  :hook                                           ;; Add hooks to enable specific features in certain modes.
  (prog-mode . display-line-numbers-mode)         ;; Enable line numbers in programming modes.
  (emacs-lisp-mode . electric-pair-mode)          ;; Enable electric pair for elisp.
  (c-mode . electric-pair-mode)          ;; Enable electric pair for c.

  :bind
  ("C-."     . 'duplicate-line)                   ;; Duplicate the current line.
  ("C-<tab>" . 'completion-at-point)              ;; Perform completion on the text around point.
  
  :init                                           ;; Initialization settings that apply before the package is loaded.

  ;; Set font
  (add-to-list 'default-frame-alist '(font . "Iosevka Extended 14"))
  ;; Maximize the frame
  ;; A “fullboth” frame, on the other hand, usually omits the title bar and occupies the entire available screen space.
  (add-to-list 'default-frame-alist '(fullscreen . fullboth))

  (tool-bar-mode -1)           ;; Disable the tool bar for a cleaner interface.
  (menu-bar-mode -1)           ;; Disable the menu bar for a more streamlined look.
  (when scroll-bar-mode
    (scroll-bar-mode -1))      ;; Disable the scroll bar if it is active.
  (show-paren-mode 1)          ;; Matching pairs of parentheses.
  ;;(load-theme 'tango-dark t)   ;; Laad tango-dark theme.
  (when (eq custom-enabled-themes nil)
  (global-hl-line-mode 1))     ; Enable highlight of the current line if theme is nil.

  (global-auto-revert-mode 1)  ;; Enable global auto-revert mode to keep buffers up to date with their corresponding files.
  (recentf-mode 1)             ;; Enable tracking of recently opened files.
  (savehist-mode 1)            ;; Enable saving of command history.
  (save-place-mode 1)          ;; Enable saving the place in files for easier return.
  (winner-mode 1)              ;; Enable winner mode to easily undo window configuration changes.
  (epa-file-enable)            ;; Encrypting and Decrypting gpg Files
  (xterm-mouse-mode 1)         ;; Enable mouse support in terminal mode.

  ;; Set the default coding system for files to UTF-8.
  (modify-coding-system-alist 'file "" 'utf-8))

(use-package org
  :ensure nil                  ;; This is built-in, no need to fetch it.
  :defer t)                    ;; Defer loading Org-mode until it's needed.

(use-package isearch
  :ensure nil                  ;; This is built-in, no need to fetch it.
  :config
  (setq isearch-lazy-count t)                  ;; Enable lazy counting to show current match information.
  (setq lazy-count-prefix-format "(%s/%s) ")   ;; Format for displaying current match count.
  (setq lazy-count-suffix-format nil)          ;; Disable suffix formatting for match count.
  (setq search-whitespace-regexp ".*?"))       ;; Allow searching across whitespace.

(use-package eldoc
  :ensure nil                  ;; This is built-in, no need to fetch it.
  :init
  (global-eldoc-mode))

(use-package flymake
  :ensure nil                  ;; This is built-in, no need to fetch it.
  :defer t
  :config
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  :hook
  (python-mode     . flymake-mode)
  (c-mode          . flymake-mode)
  (emacs-lisp-mode . flymake-mode)
  :custom
  ;; Display messages when idle, without prompting
  (help-at-pt-display-when-idle t)
  ;; Message navigation bindings
  :bind
  ("C-c n". flymake-goto-next-error)
  ("C-c p". flymake-goto-prev-error))

(use-package gnus
  :ensure nil                  ;; This is built-in, no need to fetch it.
  :defer t
  :init
  ;; Ask encryption password once.
  (defvar epa-file-cache-passphrase-for-symmetric-encryption t)

  :config
  ;; Set directory.
  (defvar message-directory "~/.config/emacs/mail/")         ;; Directory used by many mailish things.
  (setq gnus-directory "~/.config/emacs/news/")              ;; Gnus storage file and directory.
  (defvar gnus-use-dribble-file nil)                         ;; Gnus won’t create and maintain a dribble buffer.

  ;; Personal Information.
  (setq user-mail-address "ivan.guerreschi.dev@gmail.com"
	user-full-name "Ivan Guerreschi"
	user-login-name "ivan.guerreschi.dev")

  ;; read news from Gwene with Gnus.
  (setq gnus-select-method '(nntp "news.gwene.org"))

  ;; Sort thread.
  (defvar gnus-thread-sort-functions
    '(gnus-thread-sort-by-most-recent-date
      (not gnus-thread-sort-by-number)))

  ;; GMAIL.
  (add-to-list 'gnus-secondary-select-methods
	       '(nnimap "gmail"
			(nnimap-address "imap.gmail.com")
			(nnimap-server-port "imaps")
			(nnimap-stream ssl
				       (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")
				       (nnmail-expiry-wait 90))))

  ;; Send email through SMTP.
  (defvar message-send-mail-function 'smtpmail-send-it)
  (defvar smtpmail-smtp-server "smtp.gmail.com")
  (defvar smtpmail-smtp-service 465)
  (defvar smtpmail-stream-type 'tls)
  (defvar gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]"))

;; Kill all buffers
(defun nullzeiger/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; Tangle my init org file
(defun nullzeiger/tangle-dotfiles ()
  "Tangle my org file for generate init.el."
  (interactive)
  (org-babel-tangle)
  (message "Dotfile tangled"))

;; Formatting C style using indent
(defun nullzeiger/indent-format ()
  "Formatting c file using indent."
  (interactive)
  (shell-command-to-string
   (concat
    "indent --no-tabs " (buffer-file-name)))
  (revert-buffer :ignore-auto :noconfirm))

;; Create TAGS file for c
(defun nullzeiger/create-tags (dir-name)
  "Create tags file in DIR-NAME."
  (interactive "DDirectory: ")
  (eshell-command
   (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))

;; Set calendar
(require 'solar)
(setq calendar-latitude 49.5137)
(setq calendar-longitude 8.4176)
(setq calendar-location-name "Ludwigshafen")

;; Birthday
(setq holiday-other-holidays '((holiday-fixed 5 22 "Compleanno")))

;; Time 24hr format
(require 'time)
;;  Show current time in the modeline
(display-time-mode 1)
(setq display-time-format nil
      display-time-24hr-format 1)

;;; init.el ends here
