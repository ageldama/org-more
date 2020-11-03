(defun org-more-list-of-tags (base-dir tags)
  (cl-flet ((mkdttms () (format-time-string "%Y-%m-%dT%T%z")))
    (let* ((dttm (mkdttms))
           (buf-name (format "*** Org-More tag search: %s // %s @@ %s ***"
                             tags base-dir dttm))
           (buf (generate-new-buffer buf-name))
           (cmd (format "org-more.pl find %s %s"
                        base-dir tags)))
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
        (shell-command cmd buf buf)
        (insert (format "\nended-at: %s\n" (mkdttms) ))
        ;;
        (read-only-mode)))))

(org-more-list-of-tags "/home/jhyun/P/ageldama-github-io-hugo/content/posts" "rxjs")


  
