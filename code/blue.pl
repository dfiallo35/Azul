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



find_tiles_in_factory:-
    writeln(1),
    factory(Factory), !,
    retract(factory(Factory)),
    take_tiles(Factory),
find_tiles_in_factory.

%OK
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
    Array = [X|Y],
    (Tiles = X,
    right_hand(Hand),
    append([X], Hand, NewHand),
    retractall(right_hand(_)),
    assert(right_hand(NewHand)),
    find_all(Tiles, Y), !);
    (Array = [X|Y],
    left_hand(LHand),
    append([X], LHand, NewLHand),
    retract(left_hand(_)),
    assert(left_hand(NewLHand)),
    find_all(Tiles, Y)).


find_tiles_in_center.

put_tiles_in_board_left.

put_tiles_in_penalty.

move_boardleft_to_boardright.

assign_points.

end.

put_tiles_in_bag.






