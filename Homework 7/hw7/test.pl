last([A],A).
last([H|L],Z) :- last(L,Z).

flat([],[]).
flat([H|L],R) :- flat(L,F), append(H,F,R).

append1([],A,A).
/* append1(A,[],A). */
append1([H|L1],L2,[H|L]) :- append(L1,L2,L).

/*
palindrome([]).
palindrome([_]).
palindrome([H|Y]) :- palindrome(L), append(L,H,Y).
*/

palindrome(L) :- reverse(L,L).

npalindrome(L,N) :- length(L,N), palindrome(L).

union([],L,L).
union([H|A],B,U) :- union(A,B,U), member(H,U).
union([H|A],B,[H|U]) :- union(A,B,U), \+member(H,U).





/* boat problem

four entities: person, goat, cabbage, wolf

initial state: all 4 entities are on the west bank
goal state: all 4 entities are on the east bank

constraints: the boat can only take the person + 1 other entity
the cabbage and goat can't be left alone
the goat and wolf can't be left alone

state(P,C,G,W)
	variables take on either the value west or east
	
initial state: state(west,west,west,west)
goal state: state(east,east,east,east)


move(CurrState, Action, NextState)

example:
	move(state(west,west,west,west), goat, state(east,west,east,west))	
	
puzzle(Start, Goal, Actions)
	
*/	

opposite(west,east).
opposite(east,west).

move(state(P,P,G,W), cabbage, state(P2,P2,G,W)) :- opposite(P,P2), opposite(G,W).

move(state(P,C,P,W), goat, state(P2,C,P2,W)) :- opposite(P,P2).

move(state(P,C,G,P), wolf, state(P2,C,G,P2)) :- opposite(P,P2), opposite(C,G).

move(state(P,C,G,W), nothing, state(P2,C,G,W)) :- opposite(P,P2), opposite(C,G), opposite(G,W).

puzzle(Goal,Goal,[]).
puzzle(Start,Goal,[Action | Actions]) :- 
	move(Start,Action,NextState),puzzle(NextState,Goal,Actions).

/* length(Actions, 7), puzzle(state(west,west,west,west), state(east,east,east,east), Actions). */