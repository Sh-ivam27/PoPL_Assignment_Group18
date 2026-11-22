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

;; (make-inserter x len-ok?) -> (lambda (lst) ...)
;; Recursive reading: returns a function of one list. The function processes every element
;; (sublists, including the empty list, recursively through itself; atoms unchanged), then puts
;; x at the front of the processed list when len-ok? is true of the ORIGINAL list's length.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (e)
                               (cond
                                 ((or (null? e) (pair? e)) (insert e))
                                 (else e)))
                             lst)))
                (cond
                  ((len-ok? (my-length lst)) (cons x processed))
                  (else processed))))))
    insert))

;; (insert-if-short x lst n) -> list
;; Recursive reading: not recursive itself; it builds an inserter that accepts lengths below n
;; and applies it to lst.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; (print-insert-result) -> prints the result of insert-if-short on stdin input, then a newline
;; Recursive reading: not recursive; it reads x, lst and n in that order from standard input
;; (let* guarantees the reading order), then displays the result.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))
