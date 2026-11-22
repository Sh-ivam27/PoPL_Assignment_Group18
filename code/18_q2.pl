% CS F301 Assignment 2 - P2: Form a Valid Arithmetic Equation
% Group 18

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

%% split_list(+List, -Left, -Right)
%  Declarative reading: Left and Right are non-empty lists and appending
%  Left to Right gives List (order kept). On backtracking it yields every
%  split point, from Left = [first element] to Right = [last element].
%  Fails for lists with fewer than two elements.
split_list(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).

%% expr(+Numbers, -Tree, -Value)
%  Declarative reading: Tree is an expression tree that uses every number of
%  the non-empty list Numbers exactly once, in order, and Value is its integer
%  value. A tree is either n(N) for a single number N, or bin(Op, L, R) where
%  Op is one of + - * / and L, R are trees over a non-empty prefix and the
%  remaining suffix of Numbers. Every division in the tree is exact with a
%  non-zero divisor. Backtracking yields every such tree once.
expr([N], n(N), N).
expr(Numbers, bin(Op, L, R), Value) :-
    split_list(Numbers, LeftNums, RightNums),
    expr(LeftNums, L, LV),
    expr(RightNums, R, RV),
    apply_op(Op, LV, RV, Value).

%% apply_op(?Op, +X, +Y, -Value)
%  Declarative reading: Value is X Op Y for Op in + - * /. Division succeeds
%  only when Y is non-zero and divides X exactly; then // gives the exact
%  integer quotient. With Op unbound it enumerates all four operators.
apply_op(+, X, Y, V) :- V is X + Y.
apply_op(-, X, Y, V) :- V is X - Y.
apply_op(*, X, Y, V) :- V is X * Y.
apply_op(/, X, Y, V) :- Y =\= 0, X mod Y =:= 0, V is X // Y.

%% prec(?Op, ?P)
%  P is the precedence level of operator Op: * and / bind tighter (2) than
%  + and - (1).
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

%% expr_string(+Tree, -String)
%  Declarative reading: String is the canonical text of Tree: no spaces,
%  numbers in decimal, and parentheses only where the rule requires them.
%  A single number is written as itself; a node bin(Op, L, R) is the text of
%  L, then Op, then the text of R, each operand bracketed by operand_string/4.
expr_string(n(N), String) :-
    number_string(N, String).
expr_string(bin(Op, L, R), String) :-
    prec(Op, P),
    operand_string(left,  P, L, LS),
    operand_string(right, P, R, RS),
    format(string(String), "~w~w~w", [LS, Op, RS]).

%% operand_string(+Side, +ParentPrec, +Tree, -String)
%  Declarative reading: String is the text of Tree used as the Side (left or
%  right) operand of an operator with precedence ParentPrec. A number is
%  never bracketed. A sub-expression is bracketed when needs_parens/3 says so.
operand_string(_, _, n(N), String) :-
    number_string(N, String).
operand_string(Side, ParentPrec, bin(Op, L, R), String) :-
    prec(Op, ChildPrec),
    expr_string(bin(Op, L, R), Inner),
    (   needs_parens(Side, ChildPrec, ParentPrec)
    ->  format(string(String), "(~w)", [Inner])
    ;   String = Inner
    ).

%% needs_parens(+Side, +ChildPrec, +ParentPrec)
%  Left operand: bracket only if its operator binds looser than the parent's
%  (operators are left-associative, so equal precedence needs no brackets).
%  Right operand: bracket if its operator binds the same or looser.
needs_parens(left,  ChildPrec, ParentPrec) :- ChildPrec <  ParentPrec.
needs_parens(right, ChildPrec, ParentPrec) :- ChildPrec =< ParentPrec.

%% equation(+List, -Equation)
%  Declarative reading: Equation is the canonical string "L=R" where L is an
%  expression over a non-empty prefix of List, R is an expression over the
%  remaining non-empty suffix, and both have the same integer value.
%  Backtracking yields every valid equation (one per pair of trees).
equation(List, Equation) :-
    split_list(List, LeftNums, RightNums),
    expr(LeftNums, LT, V),
    expr(RightNums, RT, RV),
    V =:= RV,
    expr_string(LT, LS),
    expr_string(RT, RS),
    format(string(Equation), "~w=~w", [LS, RS]).

%% generate_equation(+List, -Equation)
%  P2.a. Equation is one valid equation for List (the first one found).
%  Fails, without looping or raising an error, when no valid equation exists;
%  lists of length 0 or 1 have no split point, so split_list/3 fails at once.
generate_equation(List, Equation) :-
    once(equation(List, Equation)).
