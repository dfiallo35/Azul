:-consult(tools).
:-consult(data_generation).


%Inicialize the game
play:-
    number_of_players,
    retractall(bag(_)), assert(bag([])),
    generate_slabs_bag,
    generate_factories,
    fill_factories,
    retractall(board(_)),
    players(P),
    retractall_board,
    generate_players_boards(P),
    retractall(center(_)),
    assert(center([])),
    random_between(1, P, ActualPlayer),
    retractall(player(_)),
    assert(player(ActualPlayer)),
    turn(1).


%body of the game
%execute all actions of the turn
turn(Turn):-
    write('*****Turn '), write(Turn), writeln('*****'),
    player(ActualPlayer),
    write('-Actual Player: '), writeln(ActualPlayer),
    not(end), !,

    % BODY
    (find_slab_in_factory, (put_slab_in_board_left, !) ; (put_slab_in_penalty, !), !);
    (find_slab_in_center, (put_slab_in_board_left, !) ; (put_slab_in_penalty, !), !);
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


find_slab_in_factory.

find_slab_in_center.

put_slab_in_board_left.

put_slab_in_penalty.

move_boardleft_to_boardright.

assign_points.

end.









a:-
    %map(generate_factory, [4], Factories).
    % generate_slabs_bag([], Bag),


    % %assert(player(1)),
    % next_player,
    % findall(X, player(X), Y),
    % writeln(Y).

    %ojo
    ((1=0, writeln(1), !) ; (2=2, writeln(2), !)) , (3=3, writeln(3)).
