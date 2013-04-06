# 在emacs中插入当前时间

	; insert-datetime
	(defun insert-datetime ()
	  "Insert date at point."
	    (interactive)
	    (insert (format-time-string "%Y-%m-%d %l:%M:%S")))