balance_rev(_,0,_,_,[],[]).
balance_rev(N,W,Num,Pow,L,R):-  
% write('('), print(W), write(','), print(Pow), print(')'), 
Newnum is Num+1, Newpow is 3*Pow, Md is W mod Newpow,
\+ W<Pow, \+ Num>N,
(   Md =:= 0*Pow, 
	balance_rev(N,W,Newnum,Newpow,L,R)
;   Md =:= 1*Pow, 
	NewW is W-Pow,
	balance_rev(N,NewW,Newnum,Newpow,L,NewR),
	R = [Num|NewR]
;   Md =:= 2*Pow,
	NewW is W+Pow,
	balance_rev(N,NewW, Newnum, Newpow, NewL, R),
	L = [Num|NewL]
).


balance(N,W,L,R):-
	balance_rev(N,W,1,1,L,R).

