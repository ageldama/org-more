;;; (use-package org-ql :ensure t :pin melpa)

;;; (use-package sqlite3 :ensure t :pin melpa)


;;; org-element-parse-buffer completely parses a (possibly narrowed) buffer into an AST. The virtual root node has type org-data and no properties attached to it.



(use-package org-ml :ensure t :pin melpa)

(use-package lispy :ensure t :pin melpa)


(print (org-ml-parse-section-at -1))




(org-ml-to-string
 (section (:begin 1 :end 106 :contents-begin 1 :contents-end 104 :post-blank 2 :post-affiliated 1 :parent nil)
          (keyword (:key "TITLE" :value "TITLE_THIS"
                         :begin 1 :end 21 :post-blank 0 :post-affiliated 1 :parent #0))
          (keyword (:key "DATE" :value "2020-10-20 00:00:00+09:00"
                         :begin 21 :end 55 :post-blank 0 :post-affiliated 21 :parent #0))
          (keyword (:key "CATEGORIES[]" :value "a-category"
                         :begin 55 :end 82 :post-blank 0 :post-affiliated 55 :parent #0))
          (keyword (:key "TAGS[]" :value "tag_a tag_b"
                         :begin 82 :end 104 :post-blank 0 :post-affiliated 82 :parent #0))))



(->> (org-ml-parse-section-at -1)
     (org-ml-get-property :end)) ;; ==> 106

;;; 즉, cdr의 첫 번째는 properties.


;;; children!
(print (cl-remove-if-not (lambda (node)
                          (and (eq 'keyword (car node))
                               (equal "TITLE" (plist-get (cadr node) :key))))
                         (->> (org-ml-parse-section-at -1)
                              (org-ml-get-children))))
;; => ((keyword (:key "TITLE" :value "TITLE_THIS" :begin 1 :end 21
;; :post-blank 0 :post-affiliated 1 ...)) (keyword (:key "DATE" :value
;; "2020-10-20 00:00:00+09:00" :begin 21 :end 55 :post-blank 0
;; :post-affiliated 21 ...)) (keyword (:key "CATEGORIES[]" :value
;; "a-category" :begin 55 :end 82 :post-blank 0 :post-affiliated 55
;; ...)) (keyword (:key "TAGS[]" :value "tag_a tag_b" :begin 82 :end
;; 104 :post-blank 0 :post-affiliated 82 ...)))


(cadr
          '(keyword (:key "TITLE" :value "TITLE_THIS"
                         :begin 1 :end 21 :post-blank 0 :post-affiliated 1 :parent 0)))



;;; 찾는 것은 완성!
(pp (cl-remove-if-not (lambda (node)
                          (and (eq 'keyword (car node))
                               (equal "TAGS[]" (plist-get (cadr node) :key))))
                         (->> (org-ml-parse-section-at -1)
                              (org-ml-get-children))))


;;; TODO https://github.com/ndwarshuis/org-ml#org-ml-update-section-at-point-fun
