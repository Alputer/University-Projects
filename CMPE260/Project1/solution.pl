%alp tuna
%2019400288
%compiling: yes
%complete: yes




%Without this, some characters were causing problem.
:- encoding(utf8).
% include the knowledge base
:- ['load.pro'].



%All utility functions are put here. 
%Actual predicates which we should implement are at the bottom.(9 predicates)



%%%%%%%%%%%%%    UTILITY FUNCTIONS BEGIN %%%%%%%%%%%%%%%%%%%%%


%%%%%%%% Divide Dashed List  %%%%%%%%%%%%%

% I took this predicate from PS !!!

divide_dashed_list([], [], []).
divide_dashed_list([Head | Tail], [HeadFirst | TailFirst] , [HeadSecond | TailSecond]):-
HeadFirst-HeadSecond = Head,
divide_dashed_list(Tail, TailFirst, TailSecond).


%%%%%%%%%%%%%%%% is in tolerance range %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This predicate is like a boolean function which does some check for conditions stated in 3.8 and 3.9

is_in_tolerance_range(TargetName, [Limits1,Limits2,Limits3,Limits4,Limits5,Limits6,Limits7,Limits8,Limits9,Limits10]):-

glanian(TargetName,_,[Feature1,Feature2,Feature3,Feature4,Feature5,Feature6,Feature7,Feature8,Feature9,Feature10]),
(Limits1 = []; [Limitdown1, Limitup1] = Limits1, Feature1 > Limitdown1, Feature1 < Limitup1 ),
(Limits2 = []; [Limitdown2, Limitup2] = Limits2, Feature2 > Limitdown2, Feature2 < Limitup2 ),
(Limits3 = []; [Limitdown3, Limitup3] = Limits3, Feature3 > Limitdown3, Feature3 < Limitup3 ),
(Limits4 = []; [Limitdown4, Limitup4] = Limits4, Feature4 > Limitdown4, Feature4 < Limitup4 ),
(Limits5 = []; [Limitdown5, Limitup5] = Limits5, Feature5 > Limitdown5, Feature5 < Limitup5 ),
(Limits6 = []; [Limitdown6, Limitup6] = Limits6, Feature6 > Limitdown6, Feature6 < Limitup6 ),
(Limits7 = []; [Limitdown7, Limitup7] = Limits7, Feature7 > Limitdown7, Feature7 < Limitup7 ),
(Limits8 = []; [Limitdown8, Limitup8] = Limits8, Feature8 > Limitdown8, Feature8 < Limitup8 ),
(Limits9 = []; [Limitdown9, Limitup9] = Limits9, Feature9 > Limitdown9, Feature9 < Limitup9 ),
(Limits10 = []; [Limitdown10, Limitup10] = Limits10, Feature10 > Limitdown10, Feature10 < Limitup10 ).


%%%%%%%%%%%%%%Discard Aliens With more than 2 activity difference. %%%%%%%%%%%%%%%%%

%This predicate is like a boolean function which does some check for conditions stated in 3.8 and 3.9

check_activity_difference(Name, TargetName):-

glanian(TargetName,_,_),
dislikes(Name,DisActivitiesList,_,_),
likes(TargetName,LikedActivitiesList,_),
list_to_set(DisActivitiesList,DisActivitiesSet),
list_to_set(LikedActivitiesList, LikedActivitiesSet),
intersection(DisActivitiesSet,LikedActivitiesSet, Result),
length(Result, L),
L =< 2.




%%%%%%%%%%%%%% All Predicates For Target Begin %%%%%%%%%%%%%%%%%%%%%



allPredicatesForTarget(Name, T, C, A, D):-

expects(Name,ExpGenderList,_),
likes(Name,LikedActivities,_),
dislikes(Name,DisActivities,DisCities,Limits),
find_possible_cities(Name, Cities),
glanian(T,Gender,_),

member(Gender, ExpGenderList), %%% One of the expected gender. Condition 6.
is_in_tolerance_range(T, Limits),  %%% Is target in the tolerance range. Coniditon 7.
check_activity_difference(Name, T), %%%% Last condition, liked activity differences. Condition 8.
\+(old_relation([Name,T])), %%% No old relation. Condition 1
\+(old_relation([T,Name])), %%% No old relation. Condition 1



city(C,_,Activities),
\+(member(C, DisCities)), %Condition 4

(member(C, Cities); 
(intersection(LikedActivities ,Activities, Result), \+(Result = []), member(A, LikedActivities))), %Condition2


merge_possible_cities(Name, T, MergedCities),
member(C, MergedCities), % Condition 5.


member(A, Activities),

\+(member(A, DisActivities)), % Condition 3

weighted_glanian_distance(Name,T,D).


%%%%%%%%%%%%%%%%%%%%%%% All Predicates For Target End %%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%% All Predicates For Match Begin %%%%%%%%%%%%%%%%%%%%%

allPredicatesForMatch(Name, T, C, A, D):-


glanian(Name,Gender1,_),
expects(Name,ExpGenderList1,_),
likes(Name,LikedActivities1,_),
dislikes(Name,DisActivities1,DisCities1,Limits1),
find_possible_cities(Name, Cities1),

glanian(T,Gender2,_),
expects(T,ExpGenderList2,_),
likes(T,LikedActivities2,_),
dislikes(T,DisActivities2,DisCities2,Limits2),

member(Gender2, ExpGenderList1), %%% One of the expected gender. Condition 7.
member(Gender1, ExpGenderList2), %%% One of the expected gender. Condition 8.
is_in_tolerance_range(T, Limits1),  %%% Is target in the tolerance range. Coniditon 9.
is_in_tolerance_range(Name, Limits2),  %%% Is target in the tolerance range. Coniditon 10.
check_activity_difference(Name, T), %%%% Liked activity differences. Condition 11.
check_activity_difference(T, Name), %%%% Liked activity differences. Condition 12.
\+(old_relation([Name,T])), %%% No old relation. Condition 1.
\+(old_relation([T,Name])), %%% No old relation. Condition 1.
find_possible_cities(T, Cities2),


city(C,_,Activities),

\+(member(C, DisCities1)), %Condition 5
\+(member(C, DisCities2)), %Condition 5

merge_possible_cities(Name, T, MergedCities),
member(C, MergedCities), % Condition 6.

member(A, Activities),
\+(member(A, DisActivities1)), % Condition 4
\+(member(A, DisActivities2)), % Condition 4


%Condition2
(member(C, Cities1); (intersection(LikedActivities1 ,Activities, Result1), \+(Result1 = []), member(A, LikedActivities1))),

%Condition3
(member(C, Cities2); (intersection(LikedActivities2 ,Activities, Result2), \+(Result2 = []), member(A, LikedActivities2))),




weighted_glanian_distance(Name,T,D1),
weighted_glanian_distance(T,Name,D2),
D is (D1+D2)/2.


%%%%%%%%%%%%%%%%%%%%%%% All Predicates For Match End %%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%    UTILITY FUNCTIONS END      %%%%%%%%%%%%%%%%%%%%%%%%











%I think this one is a bit obvious, I calculate each component and sum them.

% 3.1 glanian_distance(+Name1, +Name2, -Distance) 5 points

glanian_distance(Name1, Name2, Distance):-

expects(Name1, _,[Exp1, Exp2, Exp3, Exp4, Exp5, Exp6, Exp7, Exp8, Exp9, Exp10]), 
glanian(Name2, _, [Tar1, Tar2, Tar3, Tar4, Tar5, Tar6, Tar7, Tar8, Tar9, Tar10]), 
(Exp1 = -1, Res1 = 0; Res1 = (Exp1-Tar1)*(Exp1-Tar1)),
(Exp2 = -1, Res2 = 0; Res2 = (Exp2-Tar2)*(Exp2-Tar2)),
(Exp3 = -1, Res3 = 0; Res3 = (Exp3-Tar3)*(Exp3-Tar3)),
(Exp4 = -1, Res4 = 0; Res4 = (Exp4-Tar4)*(Exp4-Tar4)),
(Exp5 = -1, Res5 = 0; Res5 = (Exp5-Tar5)*(Exp5-Tar5)),
(Exp6 = -1, Res6 = 0; Res6 = (Exp6-Tar6)*(Exp6-Tar6)),
(Exp7 = -1, Res7 = 0; Res7 = (Exp7-Tar7)*(Exp7-Tar7)),
(Exp8 = -1, Res8 = 0; Res8 = (Exp8-Tar8)*(Exp8-Tar8)),
(Exp9 = -1, Res9 = 0; Res9 = (Exp9-Tar9)*(Exp9-Tar9)),
(Exp10 = -1, Res10 = 0; Res10 = (Exp10-Tar10)*(Exp10-Tar10)),
Sum = Res1+Res2+Res3+Res4+Res5+Res6+Res7+Res8+Res9+Res10,  % is diyince de oluyor.
Distance is sqrt(Sum),
!.


%This function is similar to the first one, only the mathematical expression is different.

% 3.2 weighted_glanian_distance(+Name1, +Name2, -Distance) 10 points

weighted_glanian_distance(Name1, Name2, Distance):-

expects(Name1, _,[Exp1, Exp2, Exp3, Exp4, Exp5, Exp6, Exp7, Exp8, Exp9, Exp10]),
glanian(Name2, _, [Tar1, Tar2, Tar3, Tar4, Tar5, Tar6, Tar7, Tar8, Tar9, Tar10]), 
weight(Name1, [Weight1, Weight2, Weight3, Weight4, Weight5, Weight6, Weight7, Weight8, Weight9, Weight10]), 
(Exp1 = -1, Res1 = 0; Res1 = (Exp1-Tar1)*(Exp1-Tar1)*Weight1),
(Exp2 = -1, Res2 = 0; Res2 = (Exp2-Tar2)*(Exp2-Tar2)*Weight2),
(Exp3 = -1, Res3 = 0; Res3 = (Exp3-Tar3)*(Exp3-Tar3)*Weight3),
(Exp4 = -1, Res4 = 0; Res4 = (Exp4-Tar4)*(Exp4-Tar4)*Weight4),
(Exp5 = -1, Res5 = 0; Res5 = (Exp5-Tar5)*(Exp5-Tar5)*Weight5),
(Exp6 = -1, Res6 = 0; Res6 = (Exp6-Tar6)*(Exp6-Tar6)*Weight6),
(Exp7 = -1, Res7 = 0; Res7 = (Exp7-Tar7)*(Exp7-Tar7)*Weight7),
(Exp8 = -1, Res8 = 0; Res8 = (Exp8-Tar8)*(Exp8-Tar8)*Weight8),
(Exp9 = -1, Res9 = 0; Res9 = (Exp9-Tar9)*(Exp9-Tar9)*Weight9),
(Exp10 = -1, Res10 = 0; Res10 = (Exp10-Tar10)*(Exp10-Tar10)*Weight10),
Sum is Res1+Res2+Res3+Res4+Res5+Res6+Res7+Res8+Res9+Res10,  % is diyince de oluyor.
Distance is sqrt(Sum),
!.



%I get the current city and liked cities seperately and combine them.

% 3.3 find_possible_cities(+Name, -CityList) 5 points

find_possible_cities(Name, CityList):-

city(CurrentCity, Residents,_),
member(Name, Residents),
likes(Name,_,LikedCities),
append([CurrentCity], LikedCities, CityListWithDuplicate),  % Don't forget the brackets !!!!!!!!!!
list_to_set(CityListWithDuplicate, CityList),
!.



% 3.4 merge_possible_cities(+Name1, +Name2, -MergedCities) 5 points

merge_possible_cities(Name1, Name2, MergedCities):-

find_possible_cities(Name1,CityList1),
find_possible_cities(Name2,CityList2),
append(CityList1,CityList2, MergedWithDuplicate),
list_to_set(MergedWithDuplicate, MergedCities),
!.


%I think predicate names are obvious.

% 3.5 find_mutual_activities(+Name1, +Name2, -MutualActivities) 5 points

find_mutual_activities(Name1, Name2, MutualActivities) :-

likes(Name1,Activities1,_),
likes(Name2,Activities2,_),
list_to_set(Activities1, Set1),
list_to_set(Activities2, Set2),
intersection(Set1, Set2, MutualActivities),
!.



%Targets should have one of the expected genders.
%I think this one will be easy with find_all_of. !!
% 3.6 find_possible_targets(+Name, -Distances, -TargetList) 10 points


find_possible_targets(Name, Distances, TargetList):-

expects(Name, GenderList,_),

findall(D-T, (glanian(T,G,_), member(G, GenderList) ,\+(Name = T), glanian_distance(Name,T,D)), Result),
sort(Result, Result2),
divide_dashed_list(Result2, Distances, TargetList),
!.


% 3.7 find_weighted_targets(+Name, -Distances, -TargetList) 15 points

find_weighted_targets(Name, Distances, TargetList):-

expects(Name, GenderList,_),

findall(D-T, (glanian(T,G,_), member(G, GenderList) ,\+(Name = T), weighted_glanian_distance(Name,T,D)), Result),
sort(Result, Result2),
divide_dashed_list(Result2, Distances, TargetList),
!.









% 3.8 find_my_best_target(+Name, -Distances, -Activities, -Cities, -Targets) 20 points

% Every condition is checked in the predicate "allPredicatesForTarget".
% Thus, this predicate seems a little short :)

find_my_best_target(Name, Distances, Activities, Cities, Targets):-

findall(D-A-C-T,allPredicatesForTarget(Name,T,C,A,D),Result),

sort(Result, Result1),  % dist1-act1-city1-target1, dist2-act2-city2-target2 .........
divide_dashed_list(Result1, Result2, Targets),
divide_dashed_list(Result2, Result3, Cities),
divide_dashed_list(Result3, Distances, Activities),
!.







%Similar to 3.8

% 3.9 find_my_best_match(+Name, -Distances, -Activities, -Cities, -Targets) 25 points

find_my_best_match(Name, Distances, Activities, Cities, Targets):-

findall(D-A-C-T,allPredicatesForMatch(Name,T,C,A,D),Result),

sort(Result, Result1),  % dist1-act1-city1-target1, dist2-act2-city2-target2 .........
divide_dashed_list(Result1, Result2, Targets),
divide_dashed_list(Result2, Result3, Cities),
divide_dashed_list(Result3, Distances, Activities),
!.





%%%%%%% PREDICATES FOR THE BONUS QUESTION %%%%%%%%%%%%%%%%%








predicates_for_ten_best(Name1,Name2,D):-

glanian(Name1,_,_),
find_my_best_match(Name1,_,_,_,Targets),

glanian(Name2,_,_),
Name1 @< Name2,
member(Name2,Targets),
weighted_glanian_distance(Name1,Name2,D1),
weighted_glanian_distance(Name2,Name1,D2),
D is (D1+D2)/2.

find_best_10_match(Best_10_Match,L):-

findall(D-Name1-Name2, predicates_for_ten_best(Name1,Name2,D), Result),
sort(Result,[_-Name11-Name12, _-Name21-Name22, _-Name31-Name32, _-Name41-Name42, _-Name51-Name52, _-Name61-Name62, _-Name71-Name72, _-Name81-Name82, _-Name91-Name92, _-Name101-Name102 | _ ]),
Best_10_Match = [Name11-Name12,Name21-Name22,Name31-Name32,Name41-Name42,Name51-Name52,Name61-Name62,Name71-Name72,Name81-Name82,Name91-Name92,Name101-Name102],
length(Best_10_Match, L),
!.








%%%%%%  BEST 10 MATCHES RESULT %%%%%%%%

%  Result = [broyrli-yvalu, pondusun-zakpha, anlyms-ragrdag, daeatal-jasori, brosyf-rotbon, bulshad-snowflog, snowfmi-yaggel, 
% alexaeth-sapli, ameram-aurav, duvrséve-nalmaje]