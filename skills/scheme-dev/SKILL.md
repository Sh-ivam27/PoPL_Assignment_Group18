---
name: scheme-dev
description: Conventions, allowed built-ins, run/test commands, self-review checklist and known AI failure modes for writing Racket 8.x (#lang racket/base) code for CS F301 Assignment 2 (files 18_q3.rkt and 18_q4.rkt). Use for every Scheme prompt in this repository.
---

# scheme-dev

## Scope and environment
- Language: **Racket 8.x** (we test on 8.18), every file starts with exactly `#lang racket/base`.
- Files: `code/18_q3.rkt` (S1 tree traversals), `code/18_q4.rkt` (S2 conditional insert).
- No `require` of any other module.

## Allowed built-ins (whitelist; anything not listed is forbidden)
`define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`),
`and`, `or`, `not`, `begin`, `quote` / `'`, `cons`, `car`, `cdr`, `list`,
all `c[ad]{1,4}r` compositions (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, ...),
`null?`, `pair?`, `eq?`, `assq`, `assoc`,
`+ - * < > <= >= =`, `max`, `display`, `newline`.
S2 only: `read`.

**Forbidden** (write your own helper instead, e.g. `my-reverse`, `my-length`, `my-map`, `my-append`):
`set!` and relatives, vectors, hash tables, strings, `do`, `for`, `for/list`, `length`, `append`,
`reverse`, `map`, `filter`, `foldl`, `foldr`, `member`, `memq`, `list-ref`, `list-tail`,
`when`, `unless`, `case`, `printf`, `write`, `print`, `number?`, `symbol?`, `list?`, `equal?`,
`void`, `apply`, `else` outside `cond`.
Note: to test "is this an atom?" use `(not (pair? x))` together with `null?` — `list?`/`symbol?` are not allowed.

## Hard rules from the assignment
1. Files contain **only definitions**. No top-level calls, no top-level `display`; loading the file prints nothing. The grader appends its own calls.
2. All state passes through function arguments (no mutation, no globals that change).
3. Every printing function ends its output with `(newline)`.
4. Print lists with `display` so they look like `(1 2 3)`; the empty list prints as `()`.
5. Prefer tail recursion where natural (accumulator + final `my-reverse`). Must cope with lists of 10,000 elements and nesting depth 100.
6. One prompt = one unit of work (one function, one test file or one review).

## Coding conventions
- Names: `kebab-case`; predicates end in `?`; helpers prefixed `my-` when they replace a forbidden built-in.
- Every function gets a header comment:
  ```racket
  ;; (fn-name arg1 arg2) -> result-type
  ;; Recursive reading: base case ...; recursive case ...
  ```
- Use `cond` with an explicit `else` clause; base case (`null?`) first.
- Use named `let` for loops with accumulators; `let*` for sequential local bindings.
- Tree access: `(car t)` = value, `(cadr t)` = left, `(caddr t)` = right; empty tree = `'()`.
- Keep functions small; one function = one job.

## How to run and test
- Load silently: `racket code/18_q3.rkt` must print **nothing**.
- Try calls: `racket -e '(require (file "code/18_q3.rkt"))'` won't see non-provided names, so test with a separate file:
  `tests/test_q3.rkt` that starts with `#lang racket/base`, does `(require "../code/18_q3.rkt")` (the code file then needs `(provide ...)`), OR simply copies the grader approach: `cat code/18_q3.rkt tests/calls_q3.rkt > /tmp/t.rkt && racket /tmp/t.rkt`.
  Prefer the `cat` approach — it matches exactly how the grader runs the file and needs no `provide`.
- S2 reads stdin: `echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket /tmp/t.rkt` where `/tmp/t.rkt` ends with `(print-insert-result)`.
- Always run the PDF examples (known-correct) plus edge cases: empty tree/list, single node, n = 0, deep nesting, long lists.

## Self-review checklist (apply before every answer)
- [ ] First line is `#lang racket/base`; no `require`.
- [ ] Every identifier used is on the whitelist or defined in this file (grep for `length`, `append`, `reverse`, `map`, `list?`, `equal?`, `when`, `set!`).
- [ ] No top-level expressions other than `define`; loading prints nothing.
- [ ] Each printing function ends with `(newline)`; output matches the spec exactly.
- [ ] Base cases handle `'()` correctly (empty tree → `()`, `(0 0)`; empty list → `(x)` when `0 < n`).
- [ ] Lengths measured on the original list (S2), before insertion.
- [ ] No quadratic `my-append` inside a loop over 10,000 elements; use accumulators + one reverse.
- [ ] Each function has a header comment with its recursive reading.
- [ ] Tested on the PDF examples plus edge cases.

## Known failure modes of AI tools in Scheme/Racket (watch for these)
- Using forbidden conveniences out of habit: `length`, `append`, `map`, `reverse`, `filter`, `list?`, `equal?`, `when`, `printf`, `for/list`.
- Adding top-level test calls or `(module+ main ...)` / `(module+ test ...)` that print on load.
- Writing `#lang racket` instead of `#lang racket/base`.
- Off-by-one in heights (empty tree is 0, single node is 1) or counting `()` as a leaf.
- Treating `()` as an atom (in S2 `()` is a list of length 0 and must get `x` inserted).
- Measuring length after inserting `x` instead of on the original list.
- Building results with repeated `append` (O(n^2)) instead of `cons` + reverse or a CPS/accumulator traversal.
- Using `write`/`print` (adds quotes) instead of `display`.
- Forgetting the final `(newline)`.
- Using `else` as a value or `if` without an else branch.
