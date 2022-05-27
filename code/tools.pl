

fill_array(_, 0, _, []):- !.
fill_array(Array, N, Obj, [X|Y]):- 
    S is N-1,
    X = Obj,
    fill_array(Array, S, Obj, Y).
    


map(_,[],[]):-!.
map(F,[X|Y],[V|R]):- T =..[F,X,V], call(T), map(F,Y,R).


insert(Val, [H|List], Index, [H|Res]):-
    Index > 1, !,
    NewIndex is Index -1,
    insert(Val, List, NewIndex, Res).
insert(Val, List, 1, [Val|List]).

replace(Val, Array, Index, NewArray):-
    nth1(Index, Array, _, NArray),
    insert(Val, NArray, Index, NewArray).