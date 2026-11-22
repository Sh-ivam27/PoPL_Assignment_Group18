---
name: prolog-dev
description: Conventions, run/test commands, self-review checklist and known AI failure modes for writing SWI-Prolog 9.x code for CS F301 Assignment 2 (files 18_q1.pl and 18_q2.pl). Use for every Prolog prompt in this repository.
---

# prolog-dev

## Scope and environment
- Language: **SWI-Prolog 9.x** (we test on 9.2.9). Use only predicates that exist in 9.x.
- Files: `code/18_q1.pl` (P1 puzzle), `code/18_q2.pl` (P2 equations).
- Allowed libraries: `lists`, `apply`, `yall`, `aggregate` only. Load them explicitly with
  `:- use_module(library(lists)).` etc. No other `use_module`.
- Double-quoted text ("...") is an SWI-Prolog **string** (SWI 7+ default `double_quotes=string`). Do not change this flag.

## Hard rules from the assignment (never break these)
1. No `assert`, `asserta`, `assertz`, `retract`, `retractall`, `b_setval`, `b_getval`, `nb_setval`, `nb_getval`, or any other global state.
2. No `:- initialization(...)` directive anywhere. Never call `halt/0` or `halt/1`.
3. A file contains **only definitions** (directives limited to `use_module`). Loading the file must print nothing.
4. Print only what the task specifies. No debug `writeln`, `format`, `print_message` left in the code.
5. P1: each clue is its own clause `clue(N, Solution)`; the answer is derived from the clues, never hard-coded.
6. P2: never build a string and parse it back (`term_string/2`, `term_to_atom/2`, `read_term_from_atom/3`, `number_codes` on an expression, etc. are forbidden for evaluation). Evaluate the expression tree directly.
7. One prompt = one unit of work (one predicate, one clue, one test file or one review). Do not write whole problems at once.

## Coding conventions
- Predicate names: `snake_case`. Variables: `CamelCase`. Helpers end with a short descriptive suffix (e.g. `split_list/3`, `eval_expr/2`).
- Every predicate gets a header comment:
  ```prolog
  %% pred_name(+In, -Out)
  %  Declarative reading: "pred_name(In, Out) holds when ..."
  ```
  Mode markers: `+` bound on call, `-` unbound on call, `?` either.
- Prefer pure, declarative code: pattern matching in clause heads, `member/2`, `select/3`, `permutation/2`.
- Use `\+` for negation only on fully bound goals (ground-check before negating).
- Use `findall/3`, `aggregate_all(count, G, N)` for collecting/counting. Use `sort/2` to dedupe and order.
- Use cuts (`!`) only when needed for determinism, and comment why. Prefer `once/1` over cut where it fits.
- Arithmetic: `is/2` only on bound expressions; compare with `=:=`, `=\=`, `<`, etc. Integer division check: `Y =\= 0, X mod Y =:= 0, Z is X // Y`.
- Strings: build with `format(string(S), Fmt, Args)` or `atomic_list_concat/2` + `atom_string/2`; numbers via `number_string/2` / `format("~d")`.
- Keep lines under ~90 characters; one clause per logical case.

## How to run and test
- Load and run main: `swipl -q -f code/18_q1.pl -g main -t halt`
- Run any goal: `swipl -q -f code/18_q2.pl -g "all_equations([4,2,5,3],Es), print(Es), nl" -t halt`
- Check the file loads silently: `swipl -q -f code/18_q1.pl -g true -t halt` must print **nothing**.
- Tests live in `tests/` (one file per problem) using `plunit` style or simple `test_*` goals that print `PASS`/`FAIL`. Tests may load the code with `:- consult('../code/18_q1.pl').` — tests are separate from solution files, so this does not violate rule 3.
- Always run the examples from the assignment PDF as tests; they are known-correct.

## Self-review checklist (apply before every answer)
- [ ] Only allowed libraries used; nothing from outside `lists/apply/yall/aggregate`.
- [ ] No assert/retract/global variables; no `initialization`; no `halt`.
- [ ] Loading the file prints nothing; no leftover debug output.
- [ ] Every predicate has a mode header and a one-line declarative reading.
- [ ] No singleton-variable warnings (use `_` or `_Name`).
- [ ] No "Clauses of X are not together" warnings (keep all clauses of a predicate contiguous; add `:- discontiguous` only if unavoidable).
- [ ] Negation (`\+`) and arithmetic only on bound terms.
- [ ] Predicate terminates: fails instead of looping on bad/empty input.
- [ ] Output format matches the spec character-for-character (spaces, commas, quotes, newline).
- [ ] Strings vs atoms vs code lists are the type the spec asks for.
- [ ] Tested on the PDF examples plus at least one edge case.

## Known failure modes of AI tools in Prolog (watch for these)
- Writing imperative-style code (loops via recursion with accumulators everywhere, `assert` for memo) instead of declarative generate-and-test.
- Hallucinated predicates or ones from other Prologs (`string_join`, `list_to_string`, GNU/SICStus-only builtins).
- Using `\+` or `is/2` on unbound variables, giving wrong answers or instantiation errors.
- Forgetting that `'c++'` and `'AI'` must be quoted atoms; printing quotes when the spec wants none (use `~w`, not `~q`).
- Confusing strings, atoms and code lists (`"abc"` is a string in SWI 7+).
- Producing duplicate solutions and not deduplicating with `sort/2`; using `setof/3` with free variables and getting backtracking per binding (prefer `findall` + `sort`).
- Infinite recursion through left recursion or unbounded generation (e.g. generating expressions without consuming the input list).
- Leaving `print`/`writeln` debugging or a `:- initialization(main).` line in the file.
- Hard-coding the answer instead of deriving it.
- Integer division with `/` (gives float/rational) instead of checking exactness and using `//`.
- Mixing clauses of the same predicate across the file, triggering discontiguous warnings.
