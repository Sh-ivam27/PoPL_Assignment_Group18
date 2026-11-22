;; Tests for S1 (code/18_q3.rkt). This file has no #lang line on purpose: it is appended to the
;; solution file, exactly as the grader does it:
;;   cat code/18_q3.rkt tests/test_q3.rkt > /tmp/run_q3.rkt && racket /tmp/run_q3.rkt

;; (run-output thunk) -> string of everything thunk prints
(define (run-output thunk)
  (let ((port (open-output-string)))
    (parameterize ((current-output-port port))
      (thunk))
    (get-output-string port)))

;; (check name thunk expected) -> 0 if the printed output equals expected, else 1 (and reports)
(define (check name thunk expected)
  (let ((actual (run-output thunk)))
    (cond
      ((equal? actual expected) 0)
      (else
       (display (list 'FAIL name 'expected expected 'got actual))
       (newline)
       1))))

;; (chain n) -> left-leaning tree of depth n, built iteratively
(define (chain n)
  (let loop ((i 0) (t '()))
    (if (= i n) t (loop (+ i 1) (list i t '())))))

(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define one '(9 () ()))
(define left-chain '(3 (2 (1 () ()) ()) ()))
(define right-chain '(1 () (2 () (3 () ()))))
(define mixed '(m (x () (y () ())) (z (w () ()) ())))

(define failures
  (+
   ;; S1.a print-inorder
   (check "inorder t1" (lambda () (print-inorder t1)) "(1 2 3 4 5 6 7)\n")
   (check "inorder t2" (lambda () (print-inorder t2)) "(1 2 3)\n")
   (check "inorder t3" (lambda () (print-inorder t3)) "(b a c)\n")
   (check "inorder empty" (lambda () (print-inorder '())) "()\n")
   (check "inorder single" (lambda () (print-inorder one)) "(9)\n")
   (check "inorder left chain" (lambda () (print-inorder left-chain)) "(1 2 3)\n")
   (check "inorder mixed" (lambda () (print-inorder mixed)) "(x y m w z)\n")
   ;; S1.b print-all-traversals
   (check "all t1" (lambda () (print-all-traversals t1))
          "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
   (check "all t2" (lambda () (print-all-traversals t2))
          "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
   (check "all t3" (lambda () (print-all-traversals t3))
          "(b a c)\n(a b c)\n(b c a)\n")
   (check "all empty" (lambda () (print-all-traversals '())) "()\n()\n()\n")
   (check "all single" (lambda () (print-all-traversals one)) "(9)\n(9)\n(9)\n")
   (check "all left chain" (lambda () (print-all-traversals left-chain))
          "(1 2 3)\n(3 2 1)\n(1 2 3)\n")
   (check "all right chain" (lambda () (print-all-traversals right-chain))
          "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
   (check "all mixed" (lambda () (print-all-traversals mixed))
          "(x y m w z)\n(m x y z w)\n(y x w z m)\n")
   ;; S1.c print-height-and-leaves
   (check "metrics t1" (lambda () (print-height-and-leaves t1)) "(3 4)\n")
   (check "metrics t2" (lambda () (print-height-and-leaves t2)) "(3 1)\n")
   (check "metrics t3" (lambda () (print-height-and-leaves t3)) "(2 2)\n")
   (check "metrics empty" (lambda () (print-height-and-leaves '())) "(0 0)\n")
   (check "metrics single" (lambda () (print-height-and-leaves one)) "(1 1)\n")
   (check "metrics left chain" (lambda () (print-height-and-leaves left-chain)) "(3 1)\n")
   (check "metrics mixed" (lambda () (print-height-and-leaves mixed)) "(3 2)\n")
   ;; deep tree
   (check "metrics deep chain" (lambda () (print-height-and-leaves (chain 10000))) "(10000 1)\n")))

(cond
  ((= failures 0) (display "ALL S1 TESTS PASSED") (newline))
  (else (display failures) (display " S1 TEST(S) FAILED") (newline) (exit 1)))
