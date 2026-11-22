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
