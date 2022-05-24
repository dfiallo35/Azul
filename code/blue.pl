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
    take_tiles(Factory).



%takes all the tiles of the same type and put them in the hand
take_tiles(Array):-
    right_hand(Hand),
    retractall(right_hand(_)),
    retractall(left_hand(_)),
    assert(right_hand([])),
    assert(left_hand([])),
    find_all(Hand, Array).

find_all(_, []):-!.
find_all(Tiles, Array):-
    Array = [X1|Y1],
    (Tiles = X1, !,
    right_hand(Hand),
    append([X1], Hand, NewHand),
    retractall(right_hand(_)),
    assert(right_hand(NewHand)),
    find_all(Tiles, Y1), !);
    (Array = [X2|Y2],
    left_hand(LHand),
    append([X2], LHand, NewLHand),
    retract(left_hand(_)),
    assert(left_hand(NewLHand)),
    find_all(Tiles, Y2)).



put_tiles_in_board_left.

put_tiles_in_penalty.

move_boardleft_to_boardright.

assign_points.

end.

put_tiles_in_bag.






