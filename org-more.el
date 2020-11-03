(defun org-more-list-of-tags* (base-dir tags)
  (cl-flet ((mkdttms () (format-time-string "%Y-%m-%dT%T%z")))
    (let* ((dttm (mkdttms))
           (buf-name (format "*** Org-More tag search: %s // %s @@ %s ***"
                             tags base-dir dttm))
           (buf (generate-new-buffer buf-name))
           (cmd (format "org-more.pl find %s %s"
                        base-dir tags))
           (exit-code nil))
      (switch-to-buffer-other-window buf)    
      (with-current-buffer buf
        (insert "-*- mode: org; -*-\n")
        (org-mode)
        (org-show-all)      
        ;;
        (insert (format "cmd: ~%s~\n" cmd))
        (insert (format "tags: %s\n" tags))
        (insert (format "base-dir: %s\n" base-dir))
        (insert (format "started-at: %s\n" dttm))
        (insert "\n")
        (setf exit-code
              (call-process-shell-command cmd nil buf buf))
        (insert (format "\nended-at: %s\n" (mkdttms)))
        (insert (format "exited-with: %s\n" exit-code))
        ;;
        (read-only-mode)))))

(defun org-more-list-of-tags ()
  (interactive)
  (let ((base-dir (read-directory-name "Dir? "))
        (tags (read-string "Enter tags: ")))
    (org-more-list-of-tags* base-dir tags)))




;;; TODO interactive ver?
