nth(0,[X|_],X):-!.
nth(N,[_|Xs],Y):-
    NewN is N-1,
    nth(NewN, Xs,Y).

% multiply(L,0,[]).
% multiply(L,N,[L|LL]):-NewN is N-1,multiply(L,NewN,LL).

pairs(_,0,[]):-!.
pairs([_|T],N,Res):-pairs(T,N,Res).
pairs([H|T],N,[H|Res]):-NewN is N-1, pairs([H|T],NewN,Res).

all_pairs([],_,[]).
all_pairs([H],55,[(55,H,7,7)]):-!.
all_pairs([H,HH|T],N,[R|Res]):-NewN is N+1,
	all_pairs([HH|T],NewN,Res),
(N mod 8 =\= 7,N<48->
	nth(6,T,Hood), R=(N,H,HH,Hood)
;N mod 8 =\= 7,N>=48->
	R=(N,H,HH,7)
;N mod 8 =:= 7,N<48->
	nth(6,T,Hood), R=(N,H,7,Hood)
).

isthere([X|_],X).
isthere([_|Xs],X):-
    isthere(Xs,X).

nulify([[]],[]):-!.
%!nulify([X],X).
nulify([[]|Ys],List):-
    nulify(Ys,List).
nulify([[X|Xs]|Ys],[X|List]):-
    nulify([Xs|Ys],List).

read_lines(_, [] ,7):-!.
read_lines(Stream, List, N):-
    read_line(Stream, NewLine),
    NewN is N+1,
    read_lines(Stream, NewList,NewN),
    List = [NewLine|NewList].

read_file(File, List):-
    open(File,read,Stream),
    read_lines(Stream, ListLists, 0),
    nulify(ListLists,List).

read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

pw(0,1). pw(1,2). pw(2,4). pw(3,8). pw(4,16). pw(5,32). pw(6,64). pw(7,128). pw(8,256). pw(9,512). 

update(N,Curr,Next,NewCurr,NewNext):-
(N mod 8 =:=7 -> NewCurr=Next,NewNext=[0,0,0,0,0,0,0,0]
; NewCurr=Curr, NewNext=Next
).

valid(N,Curr):-
    Md is (N mod 8), nth(Md,Curr,X), X=:=0.

take(0,[_|T],[1|T]):-!.
take(N,[X|T],[X|Rest]):-
    NewN is N-1, take(NewN,T,Rest).

not_taken(Md,Num,NewNum):-
    nth(Md,Num,X),X=:=0, take(Md,Num,NewNum).

validR(N,X,R,Curr,NewCurr,Dominos,[(X,R)|Dominos]):-
    R<7, \+ member((X,R),Dominos), \+ member((R,X),Dominos),
    Md is (N mod 8)+1, not_taken(Md,Curr,NewCurr).

validD(N,X,D,Next,NewNext,Dominos,[(X,D)|Dominos]):-
    D<7, \+ member((X,D),Dominos), \+ member((D,X),Dominos),
    Md is N mod 8, take(Md,Next,NewNext).

rec([(N,X,R,_)|RestList],(Dominos,Curr,Next)):-
validR(N,X,R,Curr,NewCurr1,Dominos,NewDominos),
	update(N,NewCurr1,Next,NewCurr,NewNext),
	solution(RestList,(NewDominos,NewCurr,NewNext)).

rec([(N,X,_,D)|RestList],(Dominos,Curr,Next)):-
validD(N,X,D,Next,NewNext1,Dominos,NewDominos),
	update(N,Curr,NewNext1,NewCurr,NewNext),
    	solution(RestList,(NewDominos,NewCurr,NewNext)).

solution([(55,_,_,_)],_):-
% (Dominos,Curr,Next)):-
% print(Dominos),write(','),print(Curr),write(','),print(Next),write('\n'),
% \+ valid(55,Curr),
!.
solution([(N,X,R,D)|RestList],(Dominos,Curr,Next)):-
% write('{'),print(N),write(','),print(X),write(','),print(R),write(','),print(D),write(','),
% print(Dominos),write(','),print(Curr),write(','),print(Next),
% write('}\n\n'),
(
valid(N,Curr)-> rec([(N,X,R,D)|RestList],(Dominos,Curr,Next))
    
; update(N,Curr,Next,NewCurr,NewNext), 
    solution(RestList,(Dominos,NewCurr,NewNext))
).

dominos(File, N):-
    read_file(File, InList),
%   findall(X,pairs([0,1,2,3,4,5,6],2,X),Dominos).
    Curr = [0,0,0,0,0,0,0,0],Next = [0,0,0,0,0,0,0,0],
    State =([],Curr,Next),
    all_pairs(InList,0,List),

    aggregate_all(count,solution(List,State),N).
