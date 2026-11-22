% Tests for P1 (code/18_q1.pl), Group 18.
% Run from the repository root:
%   swipl -q -f tests/test_q1.pl -g run_all -t halt
% Each test prints PASS or FAIL with its name; a summary line is printed last.

:- consult('../code/18_q1.pl').

%% check(+Name, :Goal)
%  Runs Goal once; prints "PASS Name" if it succeeds, "FAIL Name" otherwise
%  (an exception also counts as a failure).
check(Name, Goal) :-
    (   catch(once(Goal), _, fail)
    ->  format("PASS ~w~n", [Name])
    ;   format("FAIL ~w~n", [Name])
    ).

%% good(-Sol)
%  The unique solution of clues 1-9: satisfies every clue.
good([p('Alex', design, java, embedded),
      p('Ben', development, javascript, web),
      p('Carla', testing, python, 'AI'),
      p('Dana', research, 'c++', data)]).

%% other(-Sol)
%  Another solution of clues 1-8 (the first one found); violates clue 9 only.
other([p('Alex', design, java, 'AI'),
       p('Ben', development, javascript, web),
       p('Carla', research, 'c++', data),
       p('Dana', testing, python, embedded)]).

%% bad(+N, -Sol)
%  A full assignment (all values used once) that violates clue N.
%  Each is the good solution with two values swapped.
bad(1, [p('Alex', design, java, embedded), p('Ben', development, javascript, web),
        p('Carla', testing, python, data), p('Dana', research, 'c++', 'AI')]).
bad(2, [p('Alex', development, java, embedded), p('Ben', design, javascript, web),
        p('Carla', testing, python, 'AI'), p('Dana', research, 'c++', data)]).
bad(3, [p('Alex', design, java, embedded), p('Ben', development, javascript, web),
        p('Carla', testing, 'c++', 'AI'), p('Dana', research, python, data)]).
bad(4, [p('Alex', design, java, web), p('Ben', development, javascript, embedded),
        p('Carla', testing, python, 'AI'), p('Dana', research, 'c++', data)]).
bad(5, [p('Alex', design, javascript, embedded), p('Ben', development, java, web),
        p('Carla', testing, python, 'AI'), p('Dana', research, 'c++', data)]).
bad(6, [p('Alex', design, java, 'AI'), p('Ben', development, javascript, web),
        p('Carla', testing, python, embedded), p('Dana', research, 'c++', data)]).
bad(7, [p('Alex', design, 'c++', embedded), p('Ben', development, javascript, web),
        p('Carla', testing, python, 'AI'), p('Dana', research, java, data)]).
bad(8, [p('Alex', design, java, embedded), p('Ben', development, 'c++', web),
        p('Carla', testing, python, 'AI'), p('Dana', research, javascript, data)]).
bad(9, Sol) :- other(Sol).

expected_main("Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n").

%% run_all
%  Runs every test and prints a summary.
run_all :-
    % main/0: exact output, and the printed solution satisfies clues 1-8
    check(main_exact_output,
          ( with_output_to(string(Out), main), expected_main(Out) )),
    check(main_four_lines,
          ( with_output_to(string(Out2), main),
            split_string(Out2, "\n", "", Lines),
            Lines = [_, _, _, _, ""] )),
    check(main_solution_satisfies_1_to_8,
          ( other(S0), satisfies([1,2,3,4,5,6,7,8], S0) )),
    % count_solutions/2
    check(count_no_clues_13824,  count_solutions([], 13824)),
    check(count_clue1_7776,      count_solutions([1], 7776)),
    check(count_clues_3_5_1152,  count_solutions([3,5], 1152)),
    check(count_clues_1_to_8_is_3, count_solutions([1,2,3,4,5,6,7,8], 3)),
    check(count_clues_1_to_9_is_1, count_solutions([1,2,3,4,5,6,7,8,9], 1)),
    check(unique_solution_is_good,
          ( findall(S, (solution(S), satisfies([1,2,3,4,5,6,7,8,9], S)), [Only]),
            good(Only) )),
    % each clue: passes on the good solution, fails on its bad case
    forall(between(1, 9, N),
           ( format(atom(P), "clue_~w_passes_on_solution", [N]),
             check(P, ( good(G), clue(N, G) )),
             format(atom(F), "clue_~w_fails_on_violation", [N]),
             check(F, ( bad(N, B), \+ clue(N, B) ))
           )),
    % the bad cases are genuine assignments (sanity check of the tests)
    check(bad_cases_are_candidates,
          forall(bad(_, B2), solution(B2))),
    % clue 9 does not mention any friend by name (source check is manual);
    % here: it holds for exactly one of the three clue 1-8 solutions
    check(clue9_true_in_exactly_one_of_three,
          ( findall(S3, (solution(S3), satisfies([1,2,3,4,5,6,7,8], S3)), Three),
            length(Three, 3),
            include([X]>>clue(9, X), Three, Kept),
            length(Kept, 1) )),
    nl, writeln("Done.").
