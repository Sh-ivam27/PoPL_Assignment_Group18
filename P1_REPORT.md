# P1 Report: Department Assignment Puzzle, Reloaded (Group 18)

## Value of N

```
$ swipl -q -f code/18_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), print(N), nl" -t halt
3
```

**N = 3**: exactly three of the 13,824 candidate assignments (24 department
permutations x 24 language permutations x 24 project permutations) satisfy
all eight clues.

We cross-checked this value with an independent brute-force enumeration
outside Prolog, which also found exactly 3 solutions.

## The three solutions

| # | Alex | Ben | Carla | Dana |
|---|------|-----|-------|------|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## What this tells us about the puzzle

1. **The clues are consistent.** N > 0, so the eight clues do not contradict
   each other; at least one assignment satisfies all of them.
2. **The puzzle is under-constrained (not well-posed).** A proper logic puzzle
   has exactly one solution. With N = 3, clues 1 to 8 do not determine a
   unique answer, so `main/0` can only print *a* solution (the first one found
   in enumeration order), not *the* solution.
3. **What the clues do fix.** In all three solutions Ben is in development,
   uses JavaScript and prefers web. Two linked pairs also always hold:
   the tester uses Python (clue 3) and the designer uses Java (clue 5), and
   the data project always goes to the researcher, who uses C++ (clue 8).
4. **What remains ambiguous.** The clues do not decide how Alex, Carla and
   Dana are spread over research, design and testing, nor who gets the AI
   project versus the embedded project:
   - Alex is either the designer (solutions 1, 2) or the tester (solution 3).
   - Carla can be the researcher, the tester or the designer.
   - Dana is the tester in solution 1 and the researcher in solutions 2 and 3.
   - The AI project goes to Alex (1) or to Carla (2, 3).
5. **Consequence.** One more independent clue is needed to make the puzzle
   uniquely solvable. Part P1.c adds `clue(9, Solution)`, which is true in
   exactly one of these three solutions and false in the other two, so that
   `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives N = 1.
