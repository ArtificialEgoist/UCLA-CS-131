?- duplist([],[]). //true

?- duplist([1,1,2,2],[1,2]). //false

?- duplist([1,2],[1,1,2,2]). //true

?- duplist([1,2],Y). /* Y = [1, 1, 2, 2] */

?- duplist([1,2,3,1],Y). /* Y = [1, 1, 2, 2, 3, 3, 1, 1] */

?- duplist(X,[1,2,3]). //false

?- duplist(X,[1,1,2,2,3,3]). /* X = [1, 2, 3] */

?- duplist(X,[1,1,2,2,3]). //false

?- oddsize([]). //false.

?- oddsize([1]). //true.

?- oddsize([1,2,3,4,5,6]). //false.

?- oddsize([1,2,3,4,5,6,7]). //true.

?- match(y,[[x,int],[y,bool]],T).

| ?- typeInfer(function(x, plus(var(x), intconst(1))), [], T).

T = arrow(int,int) ?

| ?- typeInfer(funCall(function(x, plus(var(x), intconst(1))), intconst(34)), [], T).

T = int ?

| ?- typeInfer(if(var(x),var(y),intconst(34)), [[x,T1],[y,T2]], T).

T = int
T1 = bool
T2 = int ?

| ?- typeInfer(function(x, var(x)), [], T).

T = arrow(A,A) ?



| ?- length(Actions,10), blocksworld(world([a,b,c],[],[],none),world([],[],[a,b,c],none), Actions).

Actions = [pickup(stack1),putdown(stack2),pickup(stack1),putdown(stack2),pickup(stack1),putdown(stack3),pickup(stack2),putdown(stack3),pickup(stack2),putdown(stack3)] ?