% set_prolog_flag(toplevel_print_options,[max_depth(120)]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unit jest elementem specjalnym, który może pojawić się kilkakrotnie
% w danej kolumnie/wierszu
%     + notMemberOrUnit sprawdza, czy dany element nie znajduje się na liście.
%          chyba, że jest unitem.
%     + isUnique(List):- sprawdza nam w takim razie, czy po wyciągnięciu
%          któregokolwiek elementu z listy, pojawi się on drugi raz na pozostałej
%          liście (elementu unit mogą się powtarzać)
notMemberOrUnit(El,_) :-
  El == unit.
notMemberOrUnit(El,List) :-
  \+memberchk(El,List).
isUnique(List) :-
  forall(select(Element,List,NewList),
         notMemberOrUnit(Element,NewList)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% double generuje nam powtarzające elementy na liście. tzn,
% tzn, wiedząc, że lista ma kilka powtarzających się elementów
% wyciągamy je i tworzymy listę tych elementów
double(List,Acc) :-
  double(List,Acc,[]),!.
double(List,X,Acc) :-
  select(A,List,B),
  A \= unit,
  member(A,B),
  double(B,X,[A|Acc]).
double(_,Acc,Acc).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wstawia unity w powtarzające się miejsca
% N razy zwraca wynik, dla N powtarzających się elementów
%    + makeUniqueRow(In,Out), dla wejściowej listy, generuje taką,
%        która, powtarzające się elementy zastępuje elementem unit:
%        [1,2,2] -> [1,unit,2]
%                -> [1,2,unit]
%    + makeUnique(In,Out) wywołuje powyższy predykat dla każdej listy
%        w liście In
makeUniqueRow(In,In) :-
  isUnique(In),!.
makeUniqueRow(In,Out) :-
  double(In,Bad),
  member(El,Bad),
  append(Pre,[El|Post],In),
  append(Pre,[unit|Post],N),
  \+ once(nextto(unit,unit,N)),
  makeUniqueRow(N,Out).
makeUnique(In,Out) :-
  makeUnique(In,Out,[]).
makeUnique([],Out,Out).
makeUnique([H|T],A,Acc) :-
  makeUniqueRow(H,New),
  makeUnique(T,A,[New|Acc]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transpozycja macierzy
%   + split(In,H,T) to predykat rozdzielający wejściową listę list
%      na listę głów i ogonów, tj:
%      [ [1,2,3],[4,5,6],[7,8,9] ] -> [1,4,7],[[2,3],[5,6],[8,9]]
%   + transposeM(In,Out) w oczywisty sposób wykorzystuje split, generując
%      transpozycję macierzy
split(In,HeadsOut,TailsOut) :-
  split(In,HeadsOut,[],TailsOut,[]).
split([],H,H2,T,T2) :- lists:reverse(H2,[],H,H),lists:reverse(T2,[],T,T).
                                % reverse(H2,H),reverse(T2,T).
                                % wywołanie bezpośrednio reverse/4 daje około
                                % 1% zysk na przykładowym teście z zadania
split([ [H|T] | Tail], X,HAcc, Y,TAcc) :-
  split(Tail,X,[H|HAcc],Y,[T|TAcc]).
transposeM(In,Out) :-
  once(transposeM(In,Out,[])).
transposeM([[]|_],A,A).
transposeM(In,A,Acc) :-
  split(In,Heads,Tails),
  transposeM(Tails,A,[Heads|Acc]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drugi warunek z zadania, mówi nam, że plansza w której dwa zamalowane pola
% leżą obok siebie, jest niepoprawna.
%   + doubleUnitTest(In) sprawdza, czy w którejść z podlist listy In leżą dwa
%      elementy unit obok siebie
doubleUnitTest([]).
doubleUnitTest([H|T]) :-
  \+ once(nextto(unit,unit,H)),
  doubleUnitTest(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   + generateUniqueBoards(In,Out) otrzymuje planszę i generuje wszystkie
%      potencjalne plansze, które spełniają dwa pierwsze warunki zadania, tj.
%        1) najpierw zajmuje się wierszami, zastępuje powtarzające się
%           cyfry unitami i sprawdza, czy po zastąpieniu plansza, nie zawiera
%           dwóch sąsiadujących pól typu unit
%        2) odwraca planszę (transpozycja macierzy), tak aby zrobić to samo
%           co w pierwszym punkcie, ale dla kolumn
%        3) odwraca macierz, tak aby wróciła do początkowej wersji, sprawdzając
%           czy przypadkowo znowu nie znajdują się dwa unity obok siebie
%           (doubleUnitTest sprawdza tylko podwójne unity w wierszach, dlatego
%            po uzupełnieniu kolumn i odwróceniu macierzy należy sprawdzić
%            to jeszcze raz)
generateUniqueBoards(In,Out) :-
  findall(L,
          (makeUnique(In,InUnq),
            doubleUnitTest(InUnq),
           transposeM(InUnq,TInUnq),
           makeUnique(TInUnq,OutC),
            doubleUnitTest(OutC),
           transposeM(OutC,L),
            doubleUnitTest(L)),
          Out1),
  list_to_ord_set(Out1,Out).
                             % naiwne przerzucenie danych do zbioru
                             % uporządkowanego, usunie wygenerowane powtórzenia
                             % przy okazji czas działania dla przykładowego
                             % problemu zmniejszył się około 3-krotnie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% DRUGA CZĘŚĆ KODU, ODPOWIEDZIALNA ZA PRZECHODZENIE PLANSZY WGLAB
%%%% CHCEMY SPRAWDZIC WARUNEK, CZY Z KAZDEGO MIEJSCA, DA SIE DOJSC W INNE
%%%% TJ. CZY POLA NIE SA ODCIETE OD POZOSTALYCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 1. Najpierw każde pole dostaje indywidualny identyfikator, tak aby
%%%%    każdy z wierzchołków miał swoją nazwę. to robi predykat nazwij
%%%% 2. Tak utworzoną planszę łączymy krawędziami. Każdy sąsiad łączy się
%%%%    ze swoim sąsiadem obok (lewo,prawo), nad, oraz pod. Graf jest
%%%%    nieskierowany, dlatego dla v1 i v2 utworzone zostaną 2 krawędzie:
%%%%    edge(v1,v2), oraz edge(v2,v1).
%%%% 3. Z grafu usuwamy krawędzie łączące wierzchołki z "unitami", czyli
%%%%    wierzchołkami zamalowanymi. tj. gdy istnieje krawędź edge(v1,unit)
%%%%    jest ona usuwana z pamięci. to samo dla edge(unit,v1).
%%%% 4. dla takiego grafu stosowane jest przechodzenie wgłąb. tj. znając
%%%%    rozmiar planszy, oraz wiedząc ile jest zamalowanych elementów
%%%%    łatwo policzyć ile wierzchołków algorytm powinien odwiedzić, aby
%%%%    przejść je wszystkie. LiczbaWszystkich = Zamalowane+Numerki.
%%%%    Jeśli algorytm nie przeszedł takiej liczy wierzchołków, tzn że plansza
%%%%    nie jest poprawna. kilka elementów jest odgrodzonych od reszty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   + countUnits(In,N) zlicza nam wystąpienia elementów unit na całej planszy
%      najpierw spłasza listę, później przechodzi ją całą licząc wystąpienia
%      elementu tupu unit
c([],0).
c([unit|T],N) :-                     % brzydszy i dłuższy kod wg. kilku testów
  c(T,N1),N is N1 + 1.               % działa szybciej, dlatego zostawiam
c([H|T],N) :- H \= unit,c(T,N).      % dwie wersje, robiące to samo
countUnits(In,N) :- flatten(In,Fi),c(Fi,N).
%countUnits(In,N) :- flatten(In,Fi),findall(_,member(unit,Fi),O),length(O,N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   + name(In,Out) dodaje do każdego elementu naszej listy jakiś numerek,
%      tak aby każdy element na planszy był różny od innych (na oryginalnej
%      planszy znajduje się kilka takich samych cyfr, chcemy rozróżniać, że
%      czwórka z linii piątej, jest inna, niż czwórka z linii pierwszej.
%      dodane numerki nie mają żadnego innego znaczenia, jedynie mają
%      zapewniać unikalność na planszy)
name(In,Out) :-
  name(In,Out,[],0).
name([],X,Z,_) :- lists:reverse(X,[],Z,Z),!.
name([H|T],X,Acc,N) :-
  n(H,NewH,N,N1),
  name(T,X,[NewH|Acc],N1).
n([],[],N,N).
n([H|T],[(H,M)|X],N,M) :-
  n(T,X,N,M1),
  M is M1+1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    + createEdges(In)
%       1) dostaje planszę, z unikalnymi elementami i dynamicznie
%          generuje w pamięci graf. dla każdego wierzchołka v1 i
%          sąsiada v2 łączymy je dwiema krawędziami (graf jest skierowany,
%          ale zawsze chcemy chodzić w dwie strony). sąsiedni wierzchołek
%          v2, to znaczy wierzchołek, który na planszy leży na
%          prawo/lewo/nad/pod od wierzchołka v1
%       2) po wygenerowaniu wszystkich krawędzi, usuwamy te, które łączą
%          się z wierzchołkami unit (unit jest nazwany unikalnym identyfikatorem
%          dlatego operujemy na parze (unit,nieInteresującyNasNumer)
createEdges(In) :-
  forall(
         member(L,In),
         (
         forall(append(_,[E,N|_],L),(assert(edge(E,N)),assert(edge(N,E)))))),
  transposeM(In,TIn),
  forall(
         member(L,TIn),
         (forall(append(_,[E,N|_],L),(assert(edge(E,N)),assert(edge(N,E)))))),
  retractall(edge((unit,_),_)),
  retractall(edge(_,(unit,_))),
  !.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    + dfs(Start,ToVisit) rozpoczyna przeszukiwanie wgłąb grafu, który
%       znajduje się w pamięci maszyny prologowej. Elementem od, którego
%       rozpoczyna przeszukiwanie, jest wierzchołek Start. Zakończenie
%       przeszukiwania jest wtedy, gdy udało nam odwiedzić się każdy wierzchołek
%       w grafie. Oczywiście nie można odwiedzać dwa razy danego wierzchołka
%       Każde odwiedziny, zapamiętywane są poprzez assert(visited(Start)).
dfs(Start,ToVisit) :-
  assert(visited(Start)),
  findall(Ne,edge(Start,Ne),N1),
  findall(Me,edge(Me,Start),N2),
  append(N1,N2,Neigh),
  retractall(edge(Start,_)),
  retractall(edge(_,Start)),
  member(N,Neigh),
  \+ visited(N),
  dfs(N,ToVisit).
dfs(_,ToVisit) :-
  findall(X,visited(X),Vis),
  length(Vis,L),
  ToVisit =:= L.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   + testBoard(In) sprawdza, czy dana plansza, jest tą szukaną przez nas
%      planszą, poprzez:
%         1) "nazwanie" każdego wierzchołka
%         2) wygenerowanie grafu na podstawie planszy (połączenie nieunitów)
%         3) policzenie ile elementów, nie jest unit i na tej podstawie ile
%              elementów dfs musi odwiedzić
%         4) no i jeśli dfs odwiedził tyle elementów to jest OK, prolog mówi yes
%   + testAll(In,Out) dla listy plansz, wywołuje sprawdza kolejno predykat
%      testBoard
testBoard(Board) :-
  abolish(edge/2),
  name(Board,BNamed),createEdges(BNamed),
  edge(Start,_),
  abolish(visited/1),
  countUnits(Board,UnitsN),
  length(Board,BLen),
  ToVisit is BLen*BLen-UnitsN,
  dfs(Start,ToVisit),!.
testAll(In,Out) :-
  testAll(In,Out,[]),!.
testAll([],Out,Out).
testAll([H|T],OK,Acc) :-
  \+ member(H,Acc),
  testBoard(H),
  testAll(T,OK,[H|Acc]).
testAll([_|T],OK,Acc) :-
  testAll(T,OK,Acc).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solveFirstStep(In,Out) -> wejściem predykatu jest surowa plansza.
%  rozwiązanie polega na wygenerowaniu plansz, takich, które powtarzające
%  się elementy mają zamalowane. następnie sprawdzenie, czy taka zamalowana
%  plansza, nie odcina grupy pól z cyframi od pozostałych. wynikiem jest
%  zbiór wszystkich takich rozwiązań.
solveFirstStep(In,Out) :-
  generateUniqueBoards(In,Uniq),testAll(Uniq,T),findall(X,member(X,T),Out).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% TRZECIA CZĘŚĆ KODU, MAJĄC JUŻ GOTOWE ROZWIĄZANIA, SPEŁNIAJĄCE
%%%% WARUNKI ZADANIA, CHCEMY ZAMALOWAĆ JESZCZE KILKA BLOKÓW, TAK ABY
%%%% POWIĘKSZYĆ ILOŚĆ ROZWIĄZAŃ (CIĄGLE PAMIĘTAJĄC O TYM, ŻEBY DAŁO SIĘ
%%%% DOJŚĆ DO WSZYSTKICH ELEMENTÓW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     + addMoreUnits(In,Out) -> In to jedno z rozwiązań, taka plansza
%        która spełnia wszystkie warunki z zadania. Ale na takiej planszy
%        często można jeszcze zamalować kilka pól, ciągle spełniając
%        warunki zadania. Ten predykat bierze jeden z elementów z całej planszy
%        zamienia go w element typu unit i sprawdza, czy plansza nadal jest
%        poprawna.
%     + addMoreBoards(In,Out) -> dla zbioru gotowych rozwiązań, stara się
%        dorobić nowe rozwiązania, zaczerniając kilka pól. Po wygenerowaniu
%        nowego zbioru wywołuje się rekurencyjnie, dokładając coraz to więcej
%        rozwiązań
addMoreUnits(InBoard,Out) :-
  append(PreLine,[Line|PostLine],InBoard),
  append(Pre,[El|Post],Line),
  El \= unit,
  append(Pre,[unit|Post],NewLine),
  doubleUnitTest(NewLine),
  append(PreLine,[NewLine|PostLine],NewBoard),
  transposeM(NewBoard,TNewBoard),
  doubleUnitTest(TNewBoard),
  transposeM(TNewBoard,NewBoardOut),
  doubleUnitTest(NewBoardOut),
  testBoard(NewBoardOut),
  reverseAll(NewBoardOut,Out).
addMoreBoards(In,OutX):-
  findall(L,
          (member(X,In),
           addMoreUnits(X,L)),
          OutTemp),
  list_to_ord_set(OutTemp,Out2),
  list_to_ord_set(In,S),
  ord_union(S,Out2,Out),
  S \= Out,
  addMoreBoards(Out,OutX).
addMoreBoards(X,X).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    + solveSecondStep(In,Out) -> otrzymuje zbiór rozwiązań. do każdego
%       takiego rozwiązania dorabia nowe, zwraca niepowtarzające się rozwiązania
solveSecondStep(In,Out) :-
  findall(X,
          (member(Board,In),
          addMoreBoards([Board],X)),
          New),
  list_to_ord_set(New,Out).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    + reverseAll(In,Out) -> odwraca kolejność wszystkich elementów w podlistach
%        oraz kolejność wszystkich podlist ([[1,2],[3,4]]->[[4,3],[2,1]])
%    + flat(In,Out) -> spłaszcza o jeden poziom listę ( [ [1],[1,2]]->[1,2,1]),
%       kolejnośc jest obojęcna, dlatego druga część jest odwrócona
reverseAll(In,Out) :-
  findall(L,(member(X,In),reverse(X,L)),Out2),reverse(Out2,Out).
flat(In,Out) :-
  flat(In,Out,[]).
flat([],X,X).
flat([H|T],A,Acc) :-
  findall(A,member(A,H),L),
  append(L,Acc,Acc2),
  flat(T,A,Acc2).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    + solve(In,Out) -> otrzymując jedną sztukę planszy, algorytm generuje
%       najpierw kilka rozwiązań predykatem solveFirstStep/2, nastepnie
%       dokłada kolejne rozwiązania predykatem solveSecondStep/2. Wszystkie
%       rozwiązania są sumowane
solve(In,Out):-
  solveFirstStep(In,FirstStep),
  solveSecondStep(FirstStep,SecondStep),
  flat(SecondStep,F),
  list_to_ord_set(F,Out).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
main(File) :-
   open(File, read, _, [alias(params)]),
   read(params,_),
   read(params, Board),
   close(params),
   solve(Board,Solution),
   member(S,Solution),
   print_(S),
   nl,
   fail.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predykaty pod nie należą do rozwiązania zadania, służą jedynie
%  do wypisania rozwiązań na ekran, w bardziej "ludzkiej" formie
print_(In) :-
  i(In,I),
  forall(member(X,I),
         (forall(member(A,X),(write(A),write(' '))),nl)).

so(In,Out) :-              % transformacja listy, tak aby zamiast unit zawierała
  so(In,Out,[]),!.         % 'znaczek' zamalowania
so([],Aa,A):-reverse(A,Aa).
so([unit|T],X,Acc) :-
  so(T,X,[Acc]).
so([H|T],X,Acc) :-
  so(T,X,[H|Acc]).
i([],[]).
i([H|T],[N|X]) :-
  so(H,N),
  i(T,X).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% KILKA TESTÓW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     +test1 uświadomił mi, że gotowe rozwiązanie może zostać rozszeżone
%         poprzez zamalowanie kilku przypadkowych pól, niekonieczne tych,
%         na których znajdują się powtarzające elementy
%     +test2 oraz test3 to testy, które znajdują się w treści zadania
%  korzystanie z testów:
%              test1(X),solve(X,Y),forall(member(A,Y),(print_(A),nl)).
test1([
      [1,2,3],
      [1,4,1],
      [6,8,9]]).
test2([[3,2,1,1,1,7,6],
       [8,5,3,4,6,1,8],
       [3,8,6,7,7,6,4],
       [7,5,2,8,4,5,5],
       [6,1,2,2,8,4,3],
       [4,6,5,4,3,2,1],
       [4,7,8,6,6,4,8]]).
test3([
      [4,7,8,1,3,2,5,6],
      [5,6,1,7,4,8,2,3],
      [7,4,6,8,2,7,1,5],
      [6,3,2,4,5,1,3,7],
      [8,1,3,4,5,6,8,2],
      [4,2,3,1,8,6,7,5],
      [1,2,5,3,6,5,7,8],
      [1,6,7,5,4,3,2,8]]).
