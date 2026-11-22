#lang racket/base

;; (tree-val t) -> number or symbol
;; Recursive reading: not recursive; the value is the first element of a node (value left right).
(define (tree-val t) (car t))

;; (tree-left t) -> tree
;; Recursive reading: not recursive; the left subtree is the second element of a node.
(define (tree-left t) (cadr t))

;; (tree-right t) -> tree
;; Recursive reading: not recursive; the right subtree is the third element of a node.
(define (tree-right t) (caddr t))

;; (inorder-collect t acc) -> list
;; Recursive reading: the empty tree adds nothing to acc; otherwise the result is the
;; inorder of the left subtree followed by the node value followed by the inorder of the
;; right subtree, built right to left by consing onto acc so no append is needed.
(define (inorder-collect t acc)
  (cond
    ((null? t) acc)
    (else
     (inorder-collect (tree-left t)
                      (cons (tree-val t)
                            (inorder-collect (tree-right t) acc))))))

;; (print-inorder t) -> prints the inorder list of t on one line, then a newline
;; Recursive reading: not recursive itself; it collects the inorder values and displays them.
(define (print-inorder t)
  (display (inorder-collect t '()))
  (newline))

;; (preorder-collect t acc) -> list
;; Recursive reading: the empty tree adds nothing to acc; otherwise the result is the node
;; value followed by the preorder of the left subtree followed by the preorder of the right
;; subtree, built right to left by consing onto acc.
(define (preorder-collect t acc)
  (cond
    ((null? t) acc)
    (else
     (cons (tree-val t)
           (preorder-collect (tree-left t)
                             (preorder-collect (tree-right t) acc))))))

;; (postorder-collect t acc) -> list
;; Recursive reading: the empty tree adds nothing to acc; otherwise the result is the
;; postorder of the left subtree followed by the postorder of the right subtree followed by
;; the node value, built right to left by consing onto acc.
(define (postorder-collect t acc)
  (cond
    ((null? t) acc)
    (else
     (postorder-collect (tree-left t)
                        (postorder-collect (tree-right t)
                                           (cons (tree-val t) acc))))))

;; (print-all-traversals t) -> prints inorder, preorder and postorder lists on three lines
;; Recursive reading: not recursive itself; it displays each collected list then a newline.
(define (print-all-traversals t)
  (display (inorder-collect t '()))
  (newline)
  (display (preorder-collect t '()))
  (newline)
  (display (postorder-collect t '()))
  (newline))
