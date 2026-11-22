;; Tests for S2 (code/18_q4.rkt). No #lang line on purpose: this file is appended to the
;; solution file, exactly as the grader does it:
;;   cat code/18_q4.rkt tests/test_q4.rkt > /tmp/run_q4.rkt && racket /tmp/run_q4.rkt

;; (run-io input thunk) -> string printed by thunk while it reads input from a string
(define (run-io input thunk)
  (let ((in (open-input-string input))
        (out (open-output-string)))
    (parameterize ((current-input-port in)
                   (current-output-port out))
      (thunk))
    (get-output-string out)))

;; (check name actual expected) -> 0 if equal, else 1 (and reports)
(define (check name actual expected)
  (cond
    ((equal? actual expected) 0)
    (else
     (display (list 'FAIL name 'expected expected 'got actual))
     (newline)
     1)))

;; (stdin name input expected) -> check of print-insert-result on the given standard input
(define (stdin name input expected)
  (check name (run-io input print-insert-result) expected))

;; (nest d) -> d nested single-element lists around the empty list: (((...())...))
(define (nest d)
  (let loop ((i 0) (t '()))
    (if (= i d) t (loop (+ i 1) (list t)))))

;; (nums k) -> the list (1 2 ... k), built iteratively
(define (nums k)
  (let loop ((i k) (acc '()))
    (if (= i 0) acc (loop (- i 1) (cons i acc)))))

(define failures
  (+
   ;; S2.a print-insert-result: PDF examples, read from standard input
   (stdin "stdin pdf 1" "42 ((1 2) (3 4 5) (6) ()) 3\n" "((42 1 2) (3 4 5) (42 6) (42))\n")
   (stdin "stdin pdf 2" "0 (((1) 2) (3) ((4 5 6) ())) 3\n" "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
   (stdin "stdin pdf 3" "7 () 3\n" "(7)\n")
   (stdin "stdin pdf 4" "7 () 0\n" "()\n")
   (stdin "stdin symbol x" "a (b (c) ()) 2\n" "(b (a c) (a))\n")
   (stdin "stdin split over lines" "9\n(1\n 2)\n5\n" "(9 1 2)\n")
   ;; S2.b my-length and my-map
   (check "my-length empty" (my-length '()) 0)
   (check "my-length flat" (my-length '(a b c)) 3)
   (check "my-length counts sublists as one" (my-length '((1 2) () 3)) 3)
   (check "my-map empty" (my-map car '()) '())
   (check "my-map add1" (my-map (lambda (v) (+ v 1)) '(1 2 3)) '(2 3 4))
   (check "my-map keeps order" (my-map (lambda (v) v) '(c a b)) '(c a b))
   ;; insert-if-short (final version, built on make-inserter)
   (check "n = 0 inserts nothing" (insert-if-short 1 '(() (2) ((3))) 0) '(() (2) ((3))))
   (check "empty top-level" (insert-if-short 1 '() 1) '(1))
   (check "length on original, not after insert" (insert-if-short 5 '(()) 1) '((5)))
   (check "top-level not special" (insert-if-short 5 '((1)) 2) '(5 (5 1)))
   (check "atoms untouched" (insert-if-short 0 '(a b c) 3) '(a b c))
   (check "exact length is not short" (insert-if-short 0 '(a b c) 3) '(a b c))
   (check "deep sublist" (insert-if-short 0 '(((()))) 2) '(0 (0 (0 (0)))))
   ;; make-inserter
   (check "make-inserter even lengths"
          ((make-inserter 'x (lambda (len) (= len 2))) '((1 2) (3) (4 5) ()))
          '((x 1 2) (3) (x 4 5) ()))
   (check "make-inserter always"
          ((make-inserter 'x (lambda (len) #t)) '(() (1)))
          '(x (x) (x 1)))
   (check "make-inserter never" ((make-inserter 'x (lambda (len) #f)) '(() (1))) '(() (1)))
   ;; scale: nesting depth 100 and 10,000 elements
   (check "depth 100 output size"
          (length (let loop ((t (insert-if-short 7 (nest 100) 2)) (acc '()))
                    (if (null? (cdr t)) (cons (car t) acc) (loop (cadr t) (cons (car t) acc)))))
          101)
   (check "long list, n = 10001 inserts" (length (insert-if-short 0 (nums 10000) 10001)) 10001)
   (check "long list, n = 10000 does not" (length (insert-if-short 0 (nums 10000) 10000)) 10000)
   (check "long list of short sublists"
          (length (insert-if-short 0 (my-map (lambda (v) (list v)) (nums 10000)) 1))
          10000)))

(cond
  ((= failures 0) (display "ALL S2 TESTS PASSED") (newline))
  (else (display failures) (display " S2 TEST(S) FAILED") (newline) (exit 1)))
