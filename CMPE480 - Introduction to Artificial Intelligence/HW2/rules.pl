:- use_module(library(clpfd)).

location(1,1,1).
location(T1,R,C) :-
T0 #= T1 - 1,
RN #= R - 1,
RS #= R + 1,
CW #= C - 1,
CE #= C + 1,
(
((action(T0,hit);action(T0,clockWise);action(T0,counterClockWise)), location(T0,R,C));
(action(T0,forward), bump(T1), location(T0,R,C));
(action(T0,hit);action(T0,forward), dir(T0,north), not(bump(T1)), location(T0,RS,C));
(action(T0,hit);action(T0,forward), dir(T0,south), not(bump(T1)), location(T0,RN,C));
(action(T0,hit);action(T0,forward), dir(T0,west), not(bump(T1)), location(T0,R,CE));
(action(T0,hit);action(T0,forward), dir(T0,east), not(bump(T1)), location(T0,R,CW))
).

dir(1,east).
dir(T1,north) :-
T0 #= T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,north) );
(action(T0,clockWise) , dir(T0,west));
(action(T0,counterClockWise), dir(T0,east))
).

dir(T1,south) :-
T0 #= T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,south) );
(action(T0,clockWise) , dir(T0,east));
(action(T0,counterClockWise), dir(T0,west))
).

dir(T1,east) :-
T0 #= T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,east) );
(action(T0,clockWise) , dir(T0,north));
(action(T0,counterClockWise), dir(T0,south))
).

dir(T1,west) :-
T0 #= T1 - 1,
(
((action(T0,hit);action(T0,forward)), dir(T0,west) );
(action(T0,clockWise) , dir(T0,south));
(action(T0,counterClockWise), dir(T0,north))
).


isThereWall(T1,R,C) :-
R > 0,
C > 0,
bump(T0),
T0 < T1,
R1 is R - 1,
R2 is R + 1,
C1 is C - 1,
C2 is C + 1,
(
location(T0,R,C1), dir(T0,east);
location(T0,R,C2), dir(T0,west);
location(T0,R1,C), dir(T0,south);
location(T0,R2,C), dir(T0,north)
).



wallInFront(T) :-
location(T,R,C),
R1 is R - 1,
R2 is R + 1,
C1 is C - 1,
C2 is C + 1,
(
isThereWall(T,R1,C), dir(T,north);
isThereWall(T,R2,C), dir(T,south);
isThereWall(T,R,C1), dir(T,west);
isThereWall(T,R,C2), dir(T,east)
).


%%% ilk geldiginde wumpusSight yoksa yoktur!!!!

noWumpusForSure(T100,R,C) :-
R1 is R - 1,
R2 is R + 1,
C1 is C - 1,
C2 is C + 1,
(
R < 1;
C < 1;
(location(T1,R1,C), T1 < T100, not(wumpusSmell(T1))); %% Burada error aliyorum. Daha once burada bulundu mu???
(location(T2,R2,C), T2 < T100, not(wumpusSmell(T2)));
(location(T3,R,C1), T3 < T100, not(wumpusSmell(T3)));
(location(T4,R,C2), T4 < T100, not(wumpusSmell(T4)));
(between(1,100,T5), T5 < 100, insideRange(T5,R,C), T5 < T100,!, not(wumpusSight(T5)))  %Aslinda dogru ama soyle olmali --> insideRangeForTheFirstTime!!!!
).

%not(wumpusSight(T6), T6 < T5, insideRange(T6,R,C))

insideRange(T5,R,C) :-
R1 is R - 1,
R2 is R - 2,
R3 is R - 3,
R4 is R - 4,
R5 is R + 1,
R6 is R + 2,
R7 is R + 3,
R8 is R + 4,
C1 is C - 1,
C2 is C - 2,
C3 is C - 3,
C4 is C - 4,
C5 is C + 1,
C6 is C + 2,
C7 is C + 3,
C8 is C + 4,
(           
(dir(T5,south),(location(T5,R1,C);location(T5,R2,C);location(T5,R3,C);location(T5,R4,C)));
(dir(T5,north),(location(T5,R5,C);location(T5,R6,C);location(T5,R7,C);location(T5,R8,C)));
(dir(T5,east),(location(T5,R,C1);location(T5,R,C2);location(T5,R,C3);location(T5,R,C4)));
(dir(T5,west),(location(T5,R,C5);location(T5,R,C6);location(T5,R,C7);location(T5,R,C8)))
).


%(dir(T5,south),  T5 < T100, (location(T5,R-1,C);location(T5,R-2,C);location(T5,R-3,C);location(T5,R-4,C)), not(wumpusSight(T5)));
%(dir(T6,north),  T6 < T100, (location(T6,R+1,C);location(T6,R+2,C);location(T6,R+3,C);location(T6,R+4,C)), not(wumpusSight(T6)));
%(dir(T7,east),  T7 < T100, (location(T7,R,C-1);location(T7,R,C-2);location(T7,R,C-3);location(T7,R,C-4)), not(wumpusSight(T7)));
%(dir(T8,west),  T8 < T100, (location(T8,R,C+1);location(T8,R,C+2);location(T8,R,C+3);location(T8,R,C+4)), not(wumpusSight(T8)));



isWinner(T) :-
action(T,hit),
location(T,R,C),
R1 is R - 1,
R2 is R + 1,
C1 is C - 1,
C2 is C + 1,
(
(dir(T,north), isThereWumpusForSure(T,R1,C));   %Current direction is north, so we attacked to north
(dir(T,south), isThereWumpusForSure(T,R2,C));   %Current direction is south, so we attacked to south
(dir(T,west),  isThereWumpusForSure(T,R,C1));   %Current direction is west, so we attacked to west
(dir(T,east),  isThereWumpusForSure(T,R,C2))   %Current direction is east, so we attacked to east
).

isThereWumpusForSure(T5,R,C) :- %Attack 
R > 0,
C > 0,
(
(wumpusSmell(T0), T0 =< T5, checkSmell(T0,T5,R,C));         
(wumpusSight(T1), T1 =< T5, dir(T1,north), checkSight(T1,T5,R,C,north));
(wumpusSight(T2), T2 =< T5, dir(T2,south), checkSight(T2,T5,R,C,south)); 
(wumpusSight(T3), T3 =< T5, dir(T3,east), checkSight(T3,T5,R,C,east)); 
(wumpusSight(T4), T4 =< T5, dir(T4,west), checkSight(T4,T5,R,C,west))
).      
 


checkSmell(T0,T1,R,C) :-
R1 is R - 1,
R2 is R - 2,
R5 is R + 1,
R6 is R + 2,
C1 is C - 1,
C2 is C - 2,
C5 is C + 1,
C6 is C + 2,
(
(
location(T0,R1,C),
noWumpusForSure(T1,R1,C1), %Bu ucunde yoksa kokladigimizin o oldugundan emin olamayiz.
noWumpusForSure(T1,R1,C5),
noWumpusForSure(T1,R2,C)
);
(
location(T0,R5,C),
noWumpusForSure(T1,R5,C1),
noWumpusForSure(T1,R5,C5),
noWumpusForSure(T1,R6,C)
);
(
location(T0,R,C1),
noWumpusForSure(T1,R1,C1),
noWumpusForSure(T1,R5,C1),
noWumpusForSure(T1,R,C2)
);
(
location(T0,R,C5),
noWumpusForSure(T1,R1,C5),
noWumpusForSure(T1,R5,C5),
noWumpusForSure(T1,R,C6)
)
).

checkSight(T0,T1,R,C,north) :-
R1 is R - 1,
R2 is R - 2,
R3 is R - 3,
R5 is R + 1,
R6 is R + 2,
R7 is R + 3,
R8 is R + 4,
(
(
location(T0,R5,C),
noWumpusForSure(T1,R1,C),
noWumpusForSure(T1,R2,C),
noWumpusForSure(T1,R3,C)
);
(
location(T0,R6,C),
noWumpusForSure(T1,R5,C),
noWumpusForSure(T1,R1,C),
noWumpusForSure(T1,R2,C)
);
(
location(T0,R7,C),
noWumpusForSure(T1,R6,C),
noWumpusForSure(T1,R5,C),
noWumpusForSure(T1,R1,C)
);
(
location(T0,R8,C),
noWumpusForSure(T1,R7,C),
noWumpusForSure(T1,R6,C),
noWumpusForSure(T1,R5,C)
)
).

checkSight(T0,T1,R,C,south) :-
R1 is R - 1,
R2 is R - 2,
R3 is R - 3,
R4 is R - 4,
R5 is R + 1,
R6 is R + 2,
R7 is R + 3,
(
(
location(T0,R1,C),
noWumpusForSure(T1,R5,C),
noWumpusForSure(T1,R6,C),
noWumpusForSure(T1,R7,C)
);
(
location(T0,R2,C),
noWumpusForSure(T1,R1,C),
noWumpusForSure(T1,R5,C),
noWumpusForSure(T1,R6,C)
);
(
location(T0,R3,C),
noWumpusForSure(T1,R2,C),
noWumpusForSure(T1,R1,C),
noWumpusForSure(T1,R5,C)
);
(
location(T0,R4,C),
noWumpusForSure(T1,R3,C),
noWumpusForSure(T1,R2,C),
noWumpusForSure(T1,R1,C)
)
).

checkSight(T0,T1,R,C,east) :-
C1 is C - 1,
C2 is C - 2,
C3 is C - 3,
C4 is C - 4,
C5 is C + 1,
C6 is C + 2,
C7 is C + 3,
(
(
location(T0,R,C1),
noWumpusForSure(T1,R,C5),
noWumpusForSure(T1,R,C6),
noWumpusForSure(T1,R,C7)
);
(
location(T0,R,C2),
noWumpusForSure(T1,R,C1),
noWumpusForSure(T1,R,C5),
noWumpusForSure(T1,R,C6)
);
(
location(T0,R,C3),
noWumpusForSure(T1,R,C2),
noWumpusForSure(T1,R,C1),
noWumpusForSure(T1,R,C5)
);
(
location(T0,R,C4),
noWumpusForSure(T1,R,C3),
noWumpusForSure(T1,R,C1),
noWumpusForSure(T1,R,C1)
)
).

checkSight(T0,T1,R,C,west) :-
C1 is C - 1,
C2 is C - 2,
C3 is C - 3,
C5 is C + 1,
C6 is C + 2,
C7 is C + 3,
C8 is C + 4,
(
(
location(T0,R,C5),
noWumpusForSure(T1,R,C1),
noWumpusForSure(T1,R,C2),
noWumpusForSure(T1,R,C3)
);
(
location(T0,R,C6),
noWumpusForSure(T1,R,C5),
noWumpusForSure(T1,R,C1),
noWumpusForSure(T1,R,C2)
);
(
location(T0,R,C7),
noWumpusForSure(T1,R,C6),
noWumpusForSure(T1,R,C5),
noWumpusForSure(T1,R,C1)
);
(
location(T0,R,C8),
noWumpusForSure(T1,R,C7),
noWumpusForSure(T1,R,C6),
noWumpusForSure(T1,R,C5)
)
).












