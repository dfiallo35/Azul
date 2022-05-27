:-consult(tools).
:-consult(data_generation).


%Inicialize the game
play:-
    number_of_players,
    generate_tiles_bag,
    generate_factories,
    fill_factories,
    generate_players_boards(P),
    generate_center,
    select_random_player.
    %turn(1).


%body of the game
%execute all actions of the turn
turn(Turn):-
    write('*****Turn '), write(Turn), writeln('*****'),
    player(ActualPlayer),
    write('-Actual Player: '), writeln(ActualPlayer),
    not(end), !,

    % BODY
    (find_tiles_in_factory, (put_tiles_in_board_left, !) ; (put_tiles_in_penalty, !), !);
    (find_tiles_in_center, (put_tiles_in_board_left, !) ; (put_tiles_in_penalty, !), !);
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


%TODO: take the special tile
%OK
%take tiles from center
%if the onetile is in center, it goes to the left hand
find_tiles_in_center:-
    center(Center), !,
    retractall(center(_)),
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
    

%takes all the tiles of the same type and put them in the hand
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



put_tiles_in_board_left:-
    right_hand(RHand), !,
    length(RHand, LenRHand),
    player(Player),
    board_left(Player, LBoard).



%OK
%checks that the array has at least one free slot for tiles
free_space(Array):-
    Array = [X|Y],
    X = [], !;
    Array = [X|Y],
    free_space(Y).

%checks that the entire Array has the same color as the right hand tiles
is_same_colour(Array).

put_tiles_in_penalty.

move_boardleft_to_boardright.

assign_points.

end.


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




