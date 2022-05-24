:-consult(blue).

a:-
    %map(generate_factory, [4], Factories).
    % generate_slabs_bag([], Bag),

    % retractall(right_hand(_)),
    % retractall(left_hand(_)),
    % assert(right_hand(1)),
    % take_tiles([1,1,3,2,1,4,1]),
    % right_hand(H),
    % write('H '),writeln(H),
    % left_hand(Hh),
    % write('Hh '),writeln(Hh).

    play,
    players(P),
    write('P '),writeln(P),
    % bag(B),
    % write('B '),writeln(B),
    findall(X, factory(X), F),
    write('F '),writeln(F),
    center(C),
    write('C '),writeln(C),
    % player(PP),
    % write('PP '),writeln(PP).
    
    find_tiles_in_factory,
    findall(X, factory(X), F),
    write('F '),writeln(F),
    left_hand(LH),
    write('Lh '),writeln(LH),
    right_hand(RH),
    write('RH '),writeln(RH).
    

    
