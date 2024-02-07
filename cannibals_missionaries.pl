% Define the initial state and the goal state.
initial_state([3, 3, 0, 0, 0]).
goal_state([0, 0, 3, 3, 1]).

% Move operations: Move two missionaries, two cannibals, one missionary, one cannibal, or one missionary and one cannibal.
move([ML, CL, MR, CR, 0], [NML, CL, NMR, CR, 1]) :- ML >= 2, NML is ML-2, NMR is MR+2. % Two missionaries from left to right
move([ML, CL, MR, CR, 0], [ML, NCL, MR, NCR, 1]) :- CL >= 2, NCL is CL-2, NCR is CR+2. % Two cannibals from left to right
move([ML, CL, MR, CR, 0], [NML, CL, NMR, CR, 1]) :- ML >= 1, NML is ML-1, NMR is MR+1. % One missionary from left to right
move([ML, CL, MR, CR, 0], [ML, NCL, MR, NCR, 1]) :- CL >= 1, NCL is CL-1, NCR is CR+1. % One cannibal from left to right
move([ML, CL, MR, CR, 0], [NML, NCL, NMR, NCR, 1]) :- ML >= 1, CL >= 1, NML is ML-1, NCL is CL-1, NMR is MR+1, NCR is CR+1. % One missionary and one cannibal from left to right
% Mirror moves for boat going from right to left.
move([ML, CL, MR, CR, 1], [NML, CL, NMR, CR, 0]) :- MR >= 2, NML is ML+2, NMR is MR-2.
move([ML, CL, MR, CR, 1], [ML, NCL, MR, NCR, 0]) :- CR >= 2, NCL is CL+2, NCR is CR-2.
move([ML, CL, MR, CR, 1], [NML, CL, NMR, CR, 0]) :- MR >= 1, NML is ML+1, NMR is MR-1.
move([ML, CL, MR, CR, 1], [ML, NCL, MR, NCR, 0]) :- CR >= 1, NCL is CL+1, NCR is CR-1.
move([ML, CL, MR, CR, 1], [NML, NCL, NMR, NCR, 0]) :- MR >= 1, CR >= 1, NML is ML+1, NCL is CL+1, NMR is MR-1, NCR is CR-1.

% Ensure the state is valid: not more cannibals than missionaries on any side.
valid([ML, CL, _, _, _]) :- ML >= CL, ML > 0; CL == 0.
valid([_, _, MR, CR, _]) :- MR >= CR, MR > 0; CR == 0.

% Depth-first search to find the solution path.
solve(Start, Goal, Path) :-
    depth_first([], Start, Goal, RevPath),
    reverse(RevPath, Path).

depth_first(Path, State, Goal, [State|Path]) :- Goal = State.
depth_first(Path, State, Goal, SolPath) :-
    move(State, NextState),
    valid(NextState),
    not(member(NextState, Path)),
    depth_first([State|Path], NextState, Goal, SolPath).

% Find a solution path from the initial state to the goal.
find_solution(Path) :-
    initial_state(Start),
    goal_state(Goal),
    solve(Start, Goal, Path).
