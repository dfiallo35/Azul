:-consult(tools).
:-consult(data_generation).


%Inicialize the game
play:-
    number_of_players,
    generate_tiles_bag,
    generate_factories,
    fill_factories,
    generate_players_boards,
    generate_onetile,
    generate_leftover,
    generate_center,
    select_random_player.
    %turn(1).

%TODO: about the leftover
%TODO: fix the body
%body of the game
%execute all actions of the turn
turn(Turn):-
    write('*****Turn '), write(Turn), writeln('*****'),
    player(ActualPlayer),
    write('-Actual Player: '), writeln(ActualPlayer),
    not(end), !,

    % BODY
    (find_tiles_in_factory, put_tiles_in_board_left, !);
    (find_tiles_in_center, put_tiles_in_board_left, !);
    (move_boardleft_to_boardright, !);
    (assign_points, !),


    next_player,
    NewTurn is Turn +1,
    turn(NewTurn).


%next player to play
next_player:-
    player(ActualPlayer),
    retractall(player(_)),
    players(Players),
    S is ((ActualPlayer) mod (Players)) +1,
    assert(player(S)).


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
    retractall(right_hand(_)),
    retractall(left_hand(_)),
    (center(Center),
    nth1(_, Center, 'one', NCenter),
    retractall(center(_)),
    assert(center(NCenter)),
    f_tiles_incenter,
    retractall(left_hand(_)),
    assert(left_hand(['one'])), !);
    (f_tiles_incenter).
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
%OK
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


%TODO: working......
%left hand must be empty exept for the onetile
put_tiles_in_board_left:-
    %onetile_to_penalty,
    right_hand(RHand), !,
    length(RHand, LenRHand),
    player(Player),
    board_left(Player, LBoard).



%OK
%checks that the array has at least one free slot for tiles
free_space(Array):-
    member([], Array), !.


%OK
%checks that the entire Array has the same color as the right hand tiles
is_same_colour([]):-!.
is_same_colour(Array):-
    right_hand(RHand),
    nth1(1,RHand, Tile, _),
    Array = [X|Y],
    (X = [], ! ; X = Tile),
    is_same_colour(Y).


%TODO: important methods
move_boardleft_to_boardright.
assign_points.
end.

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
%take the one tile from left hand to player board_penalty
lefthand_to_penalty:-
    (left_hand(LeftHand),
    player(Player),
    LeftHand = [], !);
    (left_hand(LeftHand),
    player(Player),
    board_penalty(Player, Penalty),
    left_hand(LeftHand),
    nth1(Pos, Penalty, [], _), !,
    retract(board_penalty(Player, _)),
    LeftHand = [X1|Y1],
    replace(X1, Penalty, Pos, NewPenalty),
    retractall(left_hand(_)),
    assert(left_hand(Y1)),
    assert(board_penalty(Player, NewPenalty)),
    lefthand_to_penalty, !);
    (left_hand(LeftHand),
    player(Player),
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




