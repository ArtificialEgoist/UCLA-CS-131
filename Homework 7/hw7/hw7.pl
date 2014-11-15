/* Nathan Tung (004-059-195) Resources Used: CS131 Piazza, TA Office Hours */

duplist([],[]). /* duplist(X,Y) succeeds when Y is X with elements duplicated */
duplist([A|X],[A,A|Y]) :- duplist(X,Y).

oddsize([_]). /* oddsize(L) succeeds when L has odd number length */
oddsize([_,_|L]) :- oddsize(L).

/* subsetsum(L,Sum,Subset) takes list L of numbers and Sum number to produce subsequences of L Subset with numbers adding to Sum */
sum([],0). /* sum(L,S) succeeds when all elements in list L add up to sum S */
sum([A|L],S) :- sum(L,N), S is N+A.

subl([],_). /* sublist(L,Z) suceeds when L is a sublist of Z */
subl([A|L],[A|Z]) :- subl(L,Z).
subl([A|L],[_,C|Z]) :- subl([A|L],[C|Z]).

subsetsum(L,Sum,Subset) :- subl(Subset,L), sum(Subset,Sum).

/*
blocksworld
length(Actions,10), blocksworld(world([a,b,c],[],[],none),world([],[],[a,b,c],none), Actions).
*/

move(world([H|S1],S2,S3,none),pickup(stack1),world(S1,S2,S3,H)).
move(world(S1,S2,S3,H),putdown(stack1),world([H|S1],S2,S3,none)).

move(world(S1,[H|S2],S3,none),pickup(stack2),world(S1,S2,S3,H)).
move(world(S1,S2,S3,H),putdown(stack2),world(S1,[H|S2],S3,none)).

move(world(S1,S2,[H|S3],none),pickup(stack3),world(S1,S2,S3,H)).
move(world(S1,S2,S3,H),putdown(stack3),world(S1,S2,[H|S3],none)).

blocksworld(Goal,Goal,[]).
blocksworld(Start,Goal,[Action|Actions]) :- move(Start,Action,NextState), blocksworld(NextState,Goal,Actions).

/* typeInfer(E,Env,T) */

typeInfer(intconst(_),_,int).
typeInfer(boolconst(_),_,bool).
typeInfer(plus(E1,E2),Env,int) :- typeInfer(E1,Env,int), typeInfer(E2,Env,int).
typeInfer(var(E),Env,T) :- member([E,T],Env).
typeInfer(if(E1,E2,E3),Env,T) :- typeInfer(E1,Env,bool), typeInfer(E2,Env,T), typeInfer(E3,Env,T).
typeInfer(function(X,E),Env,arrow(T1,T2)) :- typeInfer(E,[[X,T1]|Env],T2).
typeInfer(funCall(E1,E2),Env,T) :- typeInfer(E1,Env,Z), typeInfer(E2,Env,A), Z=arrow(A,T).