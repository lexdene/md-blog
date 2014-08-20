;;
;; 1. global custom
;;

(setq-default make-backup-files nil)
(setq-default indent-tabs-mode nil)
; newline at end of file
(setq require-final-newline t)
; scroll
(setq scroll-step 1)
; tab
(setq default-tab-width 4)
(setq tab-stop-list (number-sequence 0 100 2))
(setq c-basic-offset 4)
; menu bar mode
(menu-bar-mode -1)
; column number mode
(setq column-number-mode t)
; another key of goto-line
(global-set-key (kbd "M-s") 'goto-line)

;;
;; 2. plugins
;;

; load path
(let ((default-directory "~/.emacs.d/lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

; insert-datetime
(defun insert-datetime ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
(global-set-key [f6] 'insert-datetime)

; linum mode
(require 'linum)
(global-linum-mode 1)

; auto complete
; apt-get install emacs-goodies-el
; apt-get install auto-complete-el
(require 'auto-complete-config)
; case sensitive matching
(setq ac-ignore-case nil)
(global-auto-complete-mode t)
(ac-config-default)

; coffee-mode
; cd ~/.emacs.d
; git clone https://github.com/lexdene/coffee-mode.git
(require 'coffee-mode)
(defun coffee-custom ()
  "coffee-mode-hook"

  ;; tab-width
  (setq coffee-tab-width 2)
  (setq tab-width 2))
(add-hook 'coffee-mode-hook 'coffee-custom)

; refresh file
(defun refresh-file ()
  (interactive)
  (revert-buffer t t t)
  (message "refresh-file ...")
)
(global-set-key [f5] 'refresh-file)

;;启用时间显示
(setq display-time-format " %Y-%m-%d %A %H:%M ")
(setq display-time-interval 10)
(display-time-mode 1)

; white space
;(global-whitespace-mode 1)
(global-set-key [f8] 'whitespace-mode)

; js indent
(setq js-indent-level 4)
(setq js-auto-indent-flag nil)

; vline
; download from http://www.emacswiki.org/emacs/download/vline.el
(require 'vline)
(global-set-key [f7] 'vline-mode)

; windmove
(global-set-key [M-down] 'windmove-down)
(global-set-key [M-up] 'windmove-up)
(global-set-key (kbd "C-c n") 'windmove-down)
(global-set-key (kbd "C-c p") 'windmove-up)
(global-set-key (kbd "C-c b") 'windmove-left)
(global-set-key (kbd "C-c f") 'windmove-right)

; compile make
(require 'compile-make)
(global-set-key [f9] 'compile-make)
(setq compilation-scroll-output t)

; grep at point
(require 'grep-at-point)
(global-set-key [f3] 'nopromp-grep-at-point)
(global-set-key (kbd "M-g M-r 1") 'nopromp-grep-at-point)
(global-set-key (kbd "M-g M-r 2") 'grep-at-point)

; show paren mode
(show-paren-mode t)

(require 'ruby-mode)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

(require 'haml-mode)
(add-to-list 'ac-modes 'haml-mode)
(modify-syntax-entry ?_ "_" haml-mode-syntax-table)

(require 'gedit-mode)
