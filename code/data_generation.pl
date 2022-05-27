%game tiles
tile('white').
tile('black').
tile('red').
tile('orange').
tile('blue').

%background right table
background([['blue', 'orange', 'red', 'black', 'white'], ['white', 'blue', 'orange', 'red', 'black'], ['black', 'white', 'blue', 'orange', 'red'], ['red', 'black', 'white', 'blue', 'orange'], ['orange', 'red', 'black', 'white', 'blue']]).

% penalty point
penalty([[-1], [-1], [-2], [-2], [-2], [-3], [-3]]).


%game tiles bag
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

%leftover tiles
:-dynamic(leftover/1).

%tile for thr firs player to take from the center
:-dynamic(onetile/1).

%tiles in the right hand of the player
%contains the tiles you are going to use
%all the tiles always have the same colour in this hand
:-dynamic(right_hand/1).

%tiles in the left hand of the player
%contains the tiles that wiil not be used, they go to the center or to the bag
:-dynamic(left_hand/1).

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


%retract all the game
retract_all:-
    retractall(left_hand(_)),
    retractall(center(_)),
    retractall(right_hand(_)),
    retractall(player(_)),
    retractall(leftover(_)),
    retractall(players(_)),
    retractall_board,
    retractall(bag(_)),
    retractall(factory(_)),
    retractall(onetile(_)).

%select the number of players
number_of_players:-
    retractall(players(_)),
    repeat, 
    writeln("write here the number of players"),
    read(Players),
    ((Players >=2, Players =< 4, assert(players(Players))), !; writeln("invalid number of players, try again"), false).



%generate the bag with 100 tiles with 20 for each color
generate_tiles_bag:-
    retractall(bag(_)),
    assert(bag([])),
    g_tiles_bag.
g_tiles_bag:-
    tile(Tile),
    bag(Bag),
    not(member(Tile, Bag)), !,
    fill_bag(20, Tile),
    g_tiles_bag.
g_tiles_bag.

%fill the bag with 20 tiles for each type
fill_bag(0, _):-!.
fill_bag(N, Tile):-
    S is N-1,
    bag(Bag),
    retractall(bag(_)),
    append([Tile], Bag, NewBag),
    assert(bag(NewBag)),
    fill_bag(S, Tile).



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

%fill the factory with N tiles
fill_factory(0, Factory):- assert(factory(Factory)), !.
fill_factory(N, Factory):-
    S is N -1,
    bag(Bag),
    length(Bag, Lb),
    random_between(1, Lb, TileIndex),
    nth1(TileIndex, Bag, Tile, NewBag),
    retractall(bag(_)),
    assert(bag(NewBag)),
    append([Tile], Factory, NewFactory),
    fill_factory(S, NewFactory).

generate_players_boards:-
    retractall_board,
    players(P),
    g_players_boards(P).

%generate the boards of the players
g_players_boards(NumberOfPlayers):-
    NumberOfPlayers > 0, !,
    assert_board(NumberOfPlayers,
    0,
    [[[]], [[], []], [[], [], []], [[], [], [], []], [[], [], [], [], []]],
    [[[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []]],
    [[], [], [], [], [], [], []]),
    N is NumberOfPlayers - 1,
    g_players_boards(N).
g_players_boards(_).



%generate de center of the factories
%put the onetile in it
generate_center:-
    retractall(center(_)),
    onetile(OneTile),
    retractall(onetile(_)),
    assert(onetile([])),
    assert(center([OneTile])).



%select a random player of the game
select_random_player:-
    players(P),
    random_between(1, P, ActualPlayer),
    retractall(player(_)),
    assert(player(ActualPlayer)).


%generate the one tile
generate_onetile:-
    retractall(onetile(_)),
    assert(onetile('one')).


%generate the leftover
generate_leftover:-
    retractall(leftover(_)),
    assert(leftover([])).