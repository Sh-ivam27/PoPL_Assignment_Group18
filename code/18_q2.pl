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
