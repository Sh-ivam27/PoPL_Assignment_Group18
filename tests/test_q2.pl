% Tests for P2 (code/18_q2.pl), Group 18.
% Run from the repository root:
%   swipl -q -f tests/test_q2.pl -g run_all -t halt
% Each test prints PASS or FAIL with its name.
% Expected lists for the edge cases were cross-checked with an independent
% brute-force enumeration written outside Prolog.

:- consult('../code/18_q2.pl').

%% check(+Name, :Goal)
%  Runs Goal once; prints "PASS Name" if it succeeds, "FAIL Name" otherwise
%  (an exception also counts as a failure).
check(Name, Goal) :-
    (   catch(once(Goal), _, fail)
    ->  format("PASS ~w~n", [Name])
    ;   format("FAIL ~w~n", [Name])
    ).

%% fails_cleanly(:Goal)
%  Goal fails without raising an exception.
fails_cleanly(Goal) :-
    catch(\+ Goal, _, fail).

%% printer_case(-Tree, -String)
%  The parenthesisation examples from the assignment PDF.
printer_case(bin(*, bin(+, n(4), n(2)), n(3)), "(4+2)*3").
printer_case(bin(+, n(4), bin(*, n(2), n(3))), "4+2*3").
printer_case(bin(*, bin(/, n(8), n(4)), n(2)), "8/4*2").
printer_case(bin(/, n(8), bin(*, n(4), n(2))), "8/(4*2)").
printer_case(bin(-, bin(-, n(1), n(2)), n(3)), "1-2-3").
printer_case(bin(-, n(1), bin(-, n(2), n(3))), "1-(2-3)").
printer_case(bin(+, n(1), bin(+, n(2), n(3))), "1+(2+3)").
printer_case(bin(+, bin(+, n(1), n(2)), n(3)), "1+2+3").

%% all_case(-Name, -List, -Expected)
%  all_equations/2 cases: PDF examples plus edge cases.
all_case(pdf_4253, [4,2,5,3],
         ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3",
          "4=2*(5-3)","4=2+(5-3)","4=2+5-3"]).
all_case(pdf_234_none, [2,3,4], []).
all_case(pdf_248, [2,4,8], ["2*4=8"]).
all_case(empty_list, [], []).
all_case(single_number, [7], []).
all_case(zeros, [0,0], ["0=0"]).
all_case(div_by_zero_1_0, [1,0], []).
all_case(div_by_zero_5_0_0, [5,0,0], ["5*0=0"]).
all_case(inexact_7_2_3, [7,2,3], []).          % 7/2 is not 3
all_case(div_chain_8241, [8,2,4,1],
         ["8/(2*4)=1","8/2/4=1","8/2=4*1","8/2=4/1",
          "8=2*(4*1)","8=2*(4/1)","8=2*4*1","8=2*4/1"]).
all_case(ones_111, [1,1,1], ["1*1=1","1/1=1","1=1*1","1=1/1"]).
all_case(longer_12345, [1,2,3,4,5],
         ["(1+2)*3-4=5","(1+2)*3=4+5","(1+2)/3+4=5","1*(2-3)=4-5",
          "1*2-3=4-5","1*2=3+(4-5)","1*2=3+4-5","1-(2-3)*4=5",
          "1/(2-3)=4-5","1=(2-3)*(4-5)","1=(2-3)*4+5","1=(2-3)/(4-5)",
          "1=2/(3+(4-5))","1=2/(3+4-5)"]).

%% run_all
%  Runs every test.
run_all :-
    % split_list/3
    check(split_list_all_points,
          findall(L-R, split_list([4,2,5,3], L, R),
                  [[4]-[2,5,3], [4,2]-[5,3], [4,2,5]-[3]])),
    check(split_list_single_fails, fails_cleanly(split_list([7], _, _))),
    check(split_list_empty_fails,  fails_cleanly(split_list([], _, _))),
    % expr/3: division rules
    check(expr_no_inexact_division, fails_cleanly(expr([7,2], bin(/,_,_), _))),
    check(expr_no_division_by_zero, fails_cleanly(expr([1,0], bin(/,_,_), _))),
    check(expr_negative_values_allowed, expr([3,5], bin(-,n(3),n(5)), -2)),
    % expr_string/2: PDF examples, result is a string
    forall(printer_case(T, S),
           ( format(atom(N1), "expr_string ~w", [S]),
             check(N1, (expr_string(T, Got), string(Got), Got == S)) )),
    check(expr_string_number, (expr_string(n(42), "42"))),
    % generate_equation/2
    check(generate_pdf_4253_is_valid,
          ( generate_equation([4,2,5,3], E1), string(E1),
            all_equations([4,2,5,3], Es1), memberchk(E1, Es1) )),
    check(generate_pdf_248, generate_equation([2,4,8], "2*4=8")),
    check(generate_pdf_234_fails, fails_cleanly(generate_equation([2,3,4], _))),
    check(generate_empty_fails,   fails_cleanly(generate_equation([], _))),
    check(generate_single_fails,  fails_cleanly(generate_equation([5], _))),
    check(generate_div_zero_no_error, fails_cleanly(generate_equation([1,0], _))),
    % all_equations/2 and count_equations/2
    forall(all_case(Name, List, Expected),
           ( format(atom(N2), "all_equations ~w", [Name]),
             check(N2, (all_equations(List, Got2), Got2 == Expected)),
             length(Expected, Len),
             format(atom(N3), "count_equations ~w = ~w", [Name, Len]),
             check(N3, count_equations(List, Len)) )),
    check(all_equations_sorted_no_duplicates,
          ( all_equations([1,2,3,4,5], Es2), sort(Es2, Es2) )),
    check(all_equations_are_strings,
          ( all_equations([4,2,5,3], Es3), forall(member(X, Es3), string(X)) )),
    nl, writeln("Done.").
