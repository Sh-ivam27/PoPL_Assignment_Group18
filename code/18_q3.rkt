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
