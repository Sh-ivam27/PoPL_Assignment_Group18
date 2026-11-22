#lang racket/base

;; (my-length lst) -> integer
;; Recursive reading: the empty list has length 0; otherwise the length is 1 more than the
;; length of the rest. Written as a named-let loop with a counter so it is tail recursive.
(define (my-length lst)
  (let loop ((l lst) (acc 0))
    (cond
      ((null? l) acc)
      (else (loop (cdr l) (+ acc 1))))))
