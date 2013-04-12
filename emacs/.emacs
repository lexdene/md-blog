(setq-default make-backup-files nil)

; insert-datetime
(defun insert-datetime ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
