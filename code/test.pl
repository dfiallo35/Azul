:-consult(blue).

a:-
    retract_all,
    play.

    % penalty_points_test.




end_test:-

    retract_all,
    assert(winner([])),
    assert(player(1)),
    assert(players(1)),
    assert(board_right(1, [[4, [], 1,2,3], [[], 2, 1,2,3], [[], [], 1,2,3]])),
    end,
    winner(W),
    ((W = [], fail, !) ; (true)),
    p('W ',W).


penalty_points_test:-
    retract_all,
    assert(player(1)),
    assert(players(2)),

    A = [1, 1, 3, 3, 5, 5, []],
    B = [1, 1, 1, 1, [], [], []],
    assert(board_penalty(1, A)),
    assert(board_penalty(2, B)),
    assert(points(1, 100)),
    assert(points(2, 100)),

    penalty_points,

    points(1, P1),
    points(2, P2),
    p('P1 ', P1),
    p('P2 ', P2).




assign_points_test:-
    retract_all,
    B = [[2, [], 1, [], []],
         [[], 1, 1, [], []], 
         [[], 1, 4, 1, 1], 
         [[], [], 5, [], []], 
         [[], [], 2, [], []]],
    assert(player(1)),
    assert(board_right(1, B)),
    assert(points(1, 0)),
    assign_points(3, 3),
    points(1, N),
    p('N ', N).


move_boardleft_to_boardright_test:-
    retract_all,
    assert(leftover([])),
    assert(player(1)),
    assert(players(3)),

    A = [['white'], ['orange', 'orange'], ['red', 'red', 'red'], [[], [], [], 'white'], [[], [], [], [], []]],
    B = [[[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []], [[], [], [], [], []]],
    assert(board_left(1, A)),
    assert(board_right(1, B)),
    assert(board_left(2, A)),
    assert(board_right(2, B)),
    assert(board_left(3, A)),
    assert(board_right(3, B)),

    move_boardleft_to_boardright,

    leftover(L),
    p('L ', L),
    board_left(1, BL),
    p('BL ', BL),
    board_right(1, BR),
    p('BR ', BR),

    leftover(L1),
    p('L1 ', L1),
    board_left(2, BL1),
    p('BL1 ', BL1),
    board_right(2, BR1),
    p('BR1 ', BR1),

    leftover(L2),
    p('L2 ', L2),
    board_left(3, BL2),
    p('BL2 ', BL2),
    board_right(3, BR2),
    p('BR2 ', BR2).



find_tiles_in_factory_test:-
    retract_all,
    assert(factory([1,1])),
    assert(center([])),

    find_tiles_in_factory,
    writeln(1),
    right_hand(R),
    p('R ', R),
    left_hand(L),
    p('L ', L),
    center(C),
    p('C ', C),

    find_tiles_in_center,
    writeln(2),
    right_hand(R1),
    p('R ', R1),
    left_hand(L1),
    p('L ', L1),
    center(C1),
    p('C ', C1).




put_tiles_in_board_left_test:-
    retract_all,
    A = [[[]], [3, []], [[], [], []]],
    B = [[[], 1, []], [[], [], []], [[], 1, []]],

    assert(right_hand([1,1,1,1,1])),
    assert(left_hand(['one'])),
    assert(player(1)),
    assert(board_left(1, A)),
    assert(board_right(1, B)),
    assert(board_penalty(1,[[],[],[],[],[],[],[]])),
    assert(leftover([])),

    put_tiles_in_board_left,
    right_hand(R),
    p('R ', R),
    left_hand(L),
    p('L ', L),
    board_left(1,BL),
    p('BL ', BL),
    board_right(1,BR),
    p('BR ', BR),
    board_penalty(1,BP),
    p('BP ', BP),
    leftover(LO),
    p('Lo ', LO).


map_test:-
    map(generate_factory, [4], _).
    generate_slabs_bag([], _).