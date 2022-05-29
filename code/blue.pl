:-consult(tools).
:-consult(data_generation).


%Initialize the game
play:-
    number_of_players,
    generate_tiles_bag,
    generate_factories,
    fill_factories,
    generate_players_boards,
    generate_hands,
    generate_onetile,
    generate_leftover,
    generate_center,
    generate_winners,
    select_random_player,
    round(1).



%TODO: working...
%body of the game
%execute all actions of the round
round(Round):-
    (write('*****Round '), write(Round), writeln('*****'),
    player(ActualPlayer),
    write('-Actual Player: '), writeln(ActualPlayer),
    player_data),
    
    % BODY
    ((find_tiles_in_factory, put_tiles_in_board_left, !);
    (find_tiles_in_center, put_tiles_in_board_left, !);
    (move_boardleft_to_boardright, penalty_points, penalty_to_leftover, put_tiles_in_bag, generate_factories, not(end), fill_factories, generate_onetile, generate_center, all_players_data, !);
    (assign_points_end, find_winner, writeln('*****Game Over*****'), !)),
    
    ((end; not(fill_factories));(player_data, next_player, NewRound is Round +1, round(NewRound))).



%OK
%take all the tiles of the same color of one factory
%the left hand ends empty
find_tiles_in_factory:-
    factory(Factory), !,
    retract(factory(Factory)),
    retractall(right_hand(_)),
    retractall(left_hand(_)),
    random_between(1, 4, Rtile),
    nth1(Rtile, Factory, ToRightHand),
    assert(right_hand(ToRightHand)),
    take_tiles(Factory),
    left_hand(LHand),
    center(Center),
    retractall(left_hand(_)),
    retractall(center(_)),
    append(LHand, Center, NewCenter),
    assert(center(NewCenter)),
    assert(left_hand([])).



%OK
%take tiles from center
%if the onetile is in center, it goes to the left hand
find_tiles_in_center:-
    (retractall(right_hand(_)),
    retractall(left_hand(_))),
    ((center(Center),
    nth1(_, Center, 'one', NCenter),
    retractall(center(_)),
    assert(center(NCenter)),
    f_tiles_incenter,
    retractall(left_hand(_)),
    assert(left_hand(['one'])), !);
    (f_tiles_incenter)).
f_tiles_incenter:-
    center(Center),
    retractall(center(_)),
    length(Center, LCenter),
    random_between(1, LCenter, RCenter),
    nth1(RCenter, Center, ToRightHand),
    assert(right_hand(ToRightHand)),
    take_tiles(Center),
    left_hand(LHand),
    retractall(left_hand(_)),
    assert(center(LHand)),
    assert(left_hand([])).

%takes all the tiles of the same type and put them in the hand
%importants in right hand and the othes in left hand
take_tiles(Array):-
    right_hand(Hand),
    retractall(right_hand(_)),
    retractall(left_hand(_)),
    assert(right_hand([])),
    assert(left_hand([])),
    find_all(Hand, Array).
find_all(_, []):-!.
find_all(RHand, Array):-
    Array = [X1|Y1],
    (RHand = X1, !,
    right_hand(Hand),
    append([X1], Hand, NewHand),
    retractall(right_hand(_)),
    assert(right_hand(NewHand)),
    find_all(RHand, Y1), !);
    (Array = [X2|Y2],
    left_hand(LHand),
    append([X2], LHand, NewLHand),
    retract(left_hand(_)),
    assert(left_hand(NewLHand)),
    find_all(RHand, Y2)).


%OK
%put the tiles from right hand to left board if it is posible
%left hand must be empty exept for the onetile
put_tiles_in_board_left:-
    lefthand_to_penalty,
    right_hand(RHand), !,
    player(Player),
    board_left(Player, LBoard),
    board_right(Player, RBoard),
    find_tile(RHand, Tile),
    find_valid_line(LBoard, RBoard, Tile, ValidLine),
    length(ValidLine, LenValidLine),
    fill_line(ValidLine, NewLine),
    replace(NewLine, LBoard, LenValidLine, NewLBoard),
    retractall(board_left(Player, _)),
    assert(board_left(Player, NewLBoard)),
    lefthand_to_penalty.

%fill the valid line from the left board
fill_line(Line, NewLine):-
    (right_hand(RHand),
    RHand = [],
    NewLine = Line, !);
    (not(free_space(Line)),
    righthand_to_lefthand,
    NewLine = Line, !);
    (right_hand(RHand),
    retractall(right_hand(_)),
    RHand = [X|Y],
    nth1(Pos, Line, [], _), !,
    replace(X, Line, Pos, NLine),
    assert(right_hand(Y)),
    fill_line(NLine, NewLine), !).

%find a valid left line to play
%with the len you can know the index
%ValidLine return one valid line in left board
find_valid_line(LBoard, RBoard, Tile, ValidLBoard):-
    (LBoard = [XL|_],
    RBoard = [XR|_],
    valid_line(XL, XR, Tile), ValidLBoard = XL, !);
    (LBoard = [_|YL],
    RBoard = [_|YR],
    find_valid_line(YL, YR, Tile, ValidLBoard)).

valid_line(ArrayLeft, ArrayRight, Tile):-
    not(member(Tile, ArrayRight)),
    free_space(ArrayLeft),
    is_same_colour(ArrayLeft, Tile).

%checks that the array has at least one free slot for tiles
free_space(Array):-
    member([], Array), !.

%checks that the entire Array has the same color as the tile
%admit arrays with no tiles
is_same_colour([], _):-!.
is_same_colour(Array, Tile):-
    Array = [X|Y],
    (X = [], ! ; X = Tile),
    is_same_colour(Y, Tile).


%OK
move_boardleft_to_boardright:-
    players(P),
    m_boardleft_to_boardright(P).

m_boardleft_to_boardright(0):- !.
m_boardleft_to_boardright(N):-
    boardleft_to_boardright(1),
    next_player,
    S is N-1,
    m_boardleft_to_boardright(S).

%OK
boardleft_to_boardright(6):- !.
boardleft_to_boardright(N):-
    (player(Player),
    board_left(Player, BoardLeft),
    nth1(N, BoardLeft, LeftLine, _),
    free_space(LeftLine),
    S is N +1,
    boardleft_to_boardright(S), !);
    (player(Player),
    board_left(Player, BoardLeft),
    nth1(N, BoardLeft, LeftLine, _),
    board_right(Player, BoardRight),
    nth1(N, BoardRight, RightLine, _),
    background(Background),
    nth1(N, Background, BackgroundLine, _),
    take_tile_from_boardleft(LeftLine),
    right_hand(RightHand),
    retractall(right_hand(_)),
    assert(right_hand([])),
    RightHand = [X|_],
    nth1(Pos, BackgroundLine, X, _),
    assign_points(N, Pos),
    replace(X, RightLine, Pos, NewRightLine),
    replace(NewRightLine, BoardRight, N, NewBoardRight),
    retractall(board_right(Player, _)),
    assert(board_right(Player, NewBoardRight)),
    retractall(board_left(Player, _)),
    fill_array(N, [], NewLeftLine),
    replace(NewLeftLine, BoardLeft, N, NewBoardLeft),
    retractall(board_left(Player, _)),
    assert(board_left(Player, NewBoardLeft)),
    S is N +1,
    boardleft_to_boardright(S), !).
%OK
%puts one of th tiles in the right hand and the rest in the leftover
take_tile_from_boardleft(LeftLine):-
    nth1(1, LeftLine, Tile, Rest),
    retractall(right_hand(_)),
    assert(right_hand([Tile])),
    leftover(Leftover),
    retractall(leftover(_)),
    append(Rest, Leftover, NewLeftover),
    assert(leftover(NewLeftover)).


%TODO: important methods
assign_points_end.
penalty_points.
end:-
    fail.
winner.


%OK
%find a tile in an array
find_tile(Array, Tile):-
    Array = [X|Y],
    ((X = [],
    find_tile(Y, Tile), !);
    (not(X = []),
    Tile = X)).


%OK
%move the useless tiles to left hand
righthand_to_lefthand:-
    right_hand(RightHand),
    retractall(right_hand(_)),
    left_hand(LeftHand),
    retractall(left_hand(_)),
    append(LeftHand, RightHand, NewLeftHand),
    assert(right_hand([])),
    assert(left_hand(NewLeftHand)).
    

%OK
%take all the tiles on left hand to penalty board
%take the one tile from left hand to player board_penalty
lefthand_to_penalty:-
    (left_hand(LeftHand),
    LeftHand = [], !);
    (left_hand(LeftHand),
    player(Player),
    board_penalty(Player, Penalty),
    nth1(Pos, Penalty, [], _), !,
    retract(board_penalty(Player, _)),
    LeftHand = [X1|Y1],
    replace(X1, Penalty, Pos, NewPenalty),
    retractall(left_hand(_)),
    assert(left_hand(Y1)),
    assert(board_penalty(Player, NewPenalty)),
    lefthand_to_penalty, !);
    (left_hand(LeftHand),
    leftover(Leftover),
    left_hand(LeftHand),
    retractall(leftover(_)),
    LeftHand = [X2|Y2],
    append([X2], Leftover, NewLeftover),
    retractall(left_hand(_)),
    assert(left_hand(Y2)),
    assert(leftover(NewLeftover)),
    lefthand_to_penalty, !).



%OK
%take all the tiles in leftover and puts them in the bag
put_tiles_in_bag:-
    leftover(Leftover),
    bag(Bag),
    retractall(leftover(_)),
    retractall(bag(_)),
    p_tiles_in_bag(Bag, Leftover).

p_tiles_in_bag(Bag, []):-
    assert(leftover([])),
    assert(bag(Bag)), !.
p_tiles_in_bag(Bag, Leftover):-
    Leftover = [X|Y],
    append([X], Bag, NewBag),
    p_tiles_in_bag(NewBag, Y).


penalty_to_leftover:-
    players(P),
    p_to_leftover(P).

p_to_leftover(0):- !.
p_to_leftover(N):-
    player(Player),
    board_penalty(Player, BPenalty),
    retractall(board_penalty(Player, _)),
    fill_array(7, [], NPenalty),
    assert(board_penalty(Player, NPenalty)),
    no_empty_slots(BPenalty, NewBPenalty),
    not(NewBPenalty = []),
    leftover(Leftover),
    retractall(leftover(_)),
    append(NewBPenalty, Leftover, NewLeftover),
    assert(leftover(NewLeftover)),
    next_player,
    S is N-1,
    p_to_leftover(S);
    next_player,
    S is N-1,
    p_to_leftover(S).

%OK
no_empty_slots(Line, NewLine):-
    nth1(_, Line, [], NLine),
    no_empty_slots(NLine, NewLine), !;
    nth1(_, Line, 'one', NLine),
    no_empty_slots(NLine, NewLine), !;
    NewLine = Line.


%OK
%assign the players points for every movement from left board to right board
assign_points(Row, Column):-
    player(Player),
    find_vertical(Row, Column),
    find_horizontal(Row, Column).

%OK
find_vertical(Row, Column):-
    NRow1 is Row -1,
    NRow2 is Row +1,
    find_up(NRow1, Column),
    find_down(NRow2, Column),
    player(Player),
    points(Player, Points),
    retractall(points(Player, _)),
    S is Points + 1,
    assert(points(Player, S)).

%OK
find_up(0, _):-!.
find_up(Row, Column):-
    (player(Player),
    board_right(Player, BoardRight),
    nth1(Row, BoardRight, Line, _),
    nth1(Column, Line, Tile, _)),
    ((Tile = [], !);
    (points(Player, Points),
    retractall(points(Player, _)),
    NewPoints is Points + 1,
    assert(points(Player, NewPoints)),
    NewRow is Row - 1,
    find_up(NewRow, Column))).

%Ok
find_down(6, _):-!.
find_down(Row, Column):-
    (player(Player),
    board_right(Player, BoardRight),
    nth1(Row, BoardRight, Line, _),
    nth1(Column, Line, Tile, _)),
    ((Tile = [], !);
    (points(Player, Points),
    retractall(points(Player, _)),
    NewPoints is Points + 1,
    assert(points(Player, NewPoints)),
    NewRow is Row + 1,
    find_down(NewRow, Column))).

find_horizontal(Row, Column):-
    NColumn1 is Column -1,
    NColumn2 is Column +1,
    find_left(Row, NColumn1),
    find_right(Row, NColumn2),
    player(Player),
    points(Player, Points),
    retractall(points(Player, _)),
    S is Points + 1,
    assert(points(Player, S)).

find_left(_, 0):-!.
find_left(Row, Column):-
    (player(Player),
    board_right(Player, BoardRight),
    nth1(Row, BoardRight, Line, _),
    nth1(Column, Line, Tile, _)),
    ((Tile = [], !);
    (points(Player, Points),
    retractall(points(Player, _)),
    NewPoints is Points + 1,
    assert(points(Player, NewPoints)),
    NewColumn is Column - 1,
    find_left(Row, NewColumn))).

find_right(_, 6):-!.
find_right(Row, Column):-
    (player(Player),
    board_right(Player, BoardRight),
    nth1(Row, BoardRight, Line, _),
    nth1(Column, Line, Tile, _)),
    ((Tile = [], !);
    (points(Player, Points),
    retractall(points(Player, _)),
    NewPoints is Points + 1,
    assert(points(Player, NewPoints)),
    NewColumn is Column + 1,
    find_right(Row, NewColumn))).
