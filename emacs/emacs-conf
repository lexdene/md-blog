(setq-default make-backup-files nil)

; insert-datetime
(defun insert-datetime ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
(global-set-key (kbd "<f9>") 'insert-datetime)

; linum mode
(global-linum-mode 1)

; auto complete
(require 'auto-complete-config)
(ac-config-default)

; newline at end of file
(setq require-final-newline t)

; scroll
(setq scroll-step 1)
