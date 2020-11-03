(require 'button)

(progn
  (insert "\n\n--> ")
  (insert-button "foo" 'action (lambda (x) (find-file user-init-file))))

