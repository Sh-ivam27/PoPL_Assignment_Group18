#lang racket/base

;; (my-length lst) -> integer
;; Recursive reading: the empty list has length 0; otherwise the length is 1 more than the
;; length of the rest. Written as a named-let loop with a counter so it is tail recursive.
(define (my-length lst)
  (let loop ((l lst) (acc 0))
    (cond
      ((null? l) acc)
      (else (loop (cdr l) (+ acc 1))))))

;; (my-reverse lst) -> list
;; Recursive reading: reversing the empty list gives the accumulator; otherwise move the first
;; element onto the front of the accumulator and reverse the rest (tail recursive).
(define (my-reverse lst)
  (let loop ((l lst) (acc '()))
    (cond
      ((null? l) acc)
      (else (loop (cdr l) (cons (car l) acc))))))

;; (my-map f lst) -> list
;; Recursive reading: mapping over the empty list gives the empty list; otherwise apply f to the
;; first element and continue with the rest. Results are accumulated in reverse and reversed
;; once at the end, so it is tail recursive and linear on lists of 10,000 elements.
(define (my-map f lst)
  (let loop ((l lst) (acc '()))
    (cond
      ((null? l) (my-reverse acc))
      (else (loop (cdr l) (cons (f (car l)) acc))))))

;; (insert-if-short x lst n) -> list
;; Recursive reading: first process every element of lst (sublists, including the empty list,
;; are processed recursively; atoms are kept as they are); then if the length of the ORIGINAL
;; lst is less than n, put x at the front of the processed list.
(define (insert-if-short x lst n)
  (let ((processed
         (my-map (lambda (e)
                   (cond
                     ((or (null? e) (pair? e)) (insert-if-short x e n))
                     (else e)))
                 lst)))
    (cond
      ((< (my-length lst) n) (cons x processed))
      (else processed))))
