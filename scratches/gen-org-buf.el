(let ((buf (generate-new-buffer "*** foobar ***")))
  (with-current-buffer buf
    (insert "-*- mode: org; -*-\n")
    (org-mode)
    ;;
    (insert "* OH HAI!\n")
    (insert "  - [[file:TODOs.org]]")
    ;;
    (read-only-mode)
    (org-show-all))
  (switch-to-buffer-other-window buf))
  
