%game slabs
slab('white').
slab('black').
slab('red').
slab('orange').
slab('blue').

%background right table
background([['blue', 'orange', 'red', 'black', 'white'], ['white', 'blue', 'orange', 'red', 'black'], ['black', 'white', 'blue', 'orange', 'red'], ['red', 'black', 'white', 'blue', 'orange'], ['orange', 'red', 'black', 'white', 'blue']]).

% penalty point
penalty([[-1], [-1], [-2], [-2], [-2], [-3], [-3]]).


%game slabs bag
:-dynamic(bag/1).
bag([]).

%game factories
:-dynamic(factory/1).

%table center
:-dynamic(center/1).

%number of players
:-dynamic(players/1).

%actual player in turn
:-dynamic(player/1).

%player personal board
:-dynamic(board/5).
board(Player, Points, BoardLeft, BoardRight, Penalty):-
    points(Player, Points),
    board_left(Player, BoardLeft),
    board_right(Player, BoardRight),
    board_penalty(Player, Penalty).

assert_board(Player, Points, BoardLeft, BoardRight, Penalty):-
    assert(points(Player, Points)),
    assert(board_left(Player, BoardLeft)),
    assert(board_right(Player, BoardRight)),
    assert(board_penalty(Player, Penalty)).

retract_board(Player, Points, BoardLeft, BoardRight, Penalty):-
    retract(points(Player, Points)),
    retract(board_left(Player, BoardLeft)),
    retract(board_right(Player, BoardRight)),
    retract(board_penalty(Player, Penalty)).

retractall_board:-
    retractall(points(_, _)),
    retractall(board_left(_, _)),
    retractall(board_right(_, _)),
    retractall(board_penalty(_, _)).

%board points
:-dynamic(points/2).

%board left
:-dynamic(board_left/2).

%board right
:-dynamic(board_right/2).

%board penalty
:-dynamic(board_penalty/2).



%select the number of players
number_of_players:-
    retractall(players(_)),
    repeat, 
    writeln("write here the number of players"),
    read(Players),
    ((Players >=2, Players =< 4, assert(players(Players))), !; writeln("invalid number of players, try again"), false).



%you must retractall bags before use this
%generate the bag with 100 slabs with 20 for each color
generate_slabs_bag:-
    slab(Slab),
    bag(Bag),
    not(member(Slab, Bag)), !,
    fill_bag(20, Slab),
    generate_slabs_bag.
generate_slabs_bag.

%fill the bag with 20 slabs for each type
fill_bag(0, Slab):-!.
fill_bag(N, Slab):-
    S is N-1,
    bag(Bag),
    retractall(bag(_)),
    append([Slab], Bag, NewBag),
    assert(bag(NewBag)),
    fill_bag(S, Slab).


%generate the factories
generate_factories:-
    players(2),
    retractall(factory(_)),
    generate_factory(5), !.
generate_factories:-
    players(3),
    retractall(factory(_)),
    generate_factory(7), !.
generate_factories:-
    players(4),
    retractall(factory(_)),
    generate_factory(9), !.

generate_factory(0).
generate_factory(N):-
    S is N-1,
    assert(factory([])),
    generate_factory(S).



%fill the factories
fill_factories:-
    (factory([]),
    retract(factory([]))), !,
    fill_factory(4, []),
    fill_factories.
fill_factories.

%fill the factory with N slabs
fill_factory(0, Factory):- assert(factory(Factory)), !.
fill_factory(N, Factory):-
    S is N -1,
    bag(Bag),
    length(Bag, Lb),
    random_between(1, Lb, SlabIndex),
    nth1(SlabIndex, Bag, Slab, NewBag),
    retractall(bag(_)),
    assert(bag(NewBag)),
    append([Slab], Factory, NewFactory),
    fill_factory(S, NewFactory).



%generate the boards of the players
generate_players_boards(NumberOfPlayers):-
    NumberOfPlayers > 0, !,
    assert_board(NumberOfPlayers,
    0,
    [[[]], [[], []], [[], [], []], [[], [], [], []], [[], [], [], [], []]],
    [[[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []]],
    [[], [], [], [], [], [], []]),
    N is NumberOfPlayers - 1,
    generate_players_boards(N).
generate_players_boards(_).