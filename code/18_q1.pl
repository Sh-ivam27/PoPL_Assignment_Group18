% CS F301 Assignment 2 - P1: Department Assignment Puzzle, Reloaded
% Group 18

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

%% depts(-Ds), langs(-Ls), projects(-Ps)
%  The four values of each attribute.
depts([research, development, design, testing]).
langs([python, java, 'c++', javascript]).
projects(['AI', web, embedded, data]).

%% solution(-Sol)
%  Declarative reading: Sol is a list of four p(Name, Dept, Lang, Project)
%  terms for Alex, Ben, Carla and Dana (in that order), where each attribute
%  takes every one of its four values exactly once. Each permutation of the
%  value lists is one assignment, so backtracking enumerates all 24^3
%  candidate solutions.
solution([p('Alex',  D1, L1, P1),
          p('Ben',   D2, L2, P2),
          p('Carla', D3, L3, P3),
          p('Dana',  D4, L4, P4)]) :-
    depts(Ds),    permutation(Ds, [D1, D2, D3, D4]),
    langs(Ls),    permutation(Ls, [L1, L2, L3, L4]),
    projects(Ps), permutation(Ps, [P1, P2, P3, P4]).

%% clue(+N, +Sol)
%  Declarative reading: clue(N, Sol) holds when clue number N is true in the
%  fully instantiated solution Sol. All clue/2 clauses are kept together.

% Clue 1: The friend who prefers the AI project does not work in research
% and is not Dana.
clue(1, Sol) :-
    member(p(Name, Dept, _, 'AI'), Sol),
    Dept \== research,
    Name \== 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
% ("prefer C++" refers to Alex's favorite language.)
clue(2, Sol) :-
    member(p('Alex', Dept, Lang, _), Sol),
    Dept \== development,
    Lang \== 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Sol) :-
    member(p(_, testing, python, _), Sol).
