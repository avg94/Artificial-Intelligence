:- use_module(library(clpfd)).
:- set_prolog_stack(global, limit(100 000 000)).
%---------------------------------------------------------------
%   Facts enumerating the four allowed suits
%---------------------------------------------------------------

suit(hearts).
suit(clubs).
suit(spades).
suit(diamonds).

%---------------------------------------------------------------
%  card(I, J) defines what a card is. 
%  This is useful for extracting the suit or number of a card.
%
%  I is the cards number; J is the cards suit.
%---------------------------------------------------------------

card(I, J) :-
		integer(I),
		suit(J).
%---------------------------------------------------------------
%  play is the main function to start the game play
% Step 1. Shuffling of cards
% Step 2. Dealt the card to a player to have 5 cards
% Step 3. Display three cards in hand, keep rest two cards hidden.
% Step 4. Find the possibilities of different ranks, display the list
% Step 6. Show the actual rank with all five cards
%---------------------------------------------------------------

play :- playpoker(14,6).

playpoker(ChipAValue,ChipBValue) :-	
		write('LETS LOOSE SOME MONEY!!!'),nl,nl,
		HouseOfCards = [card(1,hearts),card(2,hearts),card(3,hearts),card(4,hearts),card(5,hearts),card(6,hearts),card(7,hearts),
				card(8,hearts),card(9,hearts),card(10,hearts),card(11,hearts),card(12,hearts),card(13,hearts),
				
				card(1,spades),card(2,spades),card(3,spades),card(4,spades),card(5,spades),card(6,spades),card(7,spades),
				card(8,spades),card(9,spades),card(10,spades),card(11,spades),card(12,spades),card(13,spades),

				card(1,diamonds),card(2,diamonds),card(3,diamonds),card(4,diamonds),card(5,diamonds),card(6,diamonds),
				card(7,diamonds),card(8,diamonds),card(9,diamonds),card(10,diamonds),card(11,diamonds),card(12,diamonds),
				card(13,diamonds),

				card(1,clubs),card(2,clubs),card(3,clubs),card(4,clubs),card(5,clubs),card(6,clubs),card(7,clubs),
				card(8,clubs),card(9,clubs),card(10,clubs),card(11,clubs),card(12,clubs),card(13,clubs)],		
		
		write('Cards are shuffled!'),nl,

		nl,write('Dealing Cards.....'),nl,nl,
		PotValue = 2,

		PlayerAChipValue is ChipAValue,
		PlayerBChipValue is ChipBValue,
		
		CardsInHandForPlayer1 = [A1,A2,A3,A4,A5],
		CardsInHandForPlayer2 = [B1,B2,B3,B4,B5],
		random_select(A1,HouseOfCards,Rest),
		random_select(B1,Rest,Rest1),
		random_select(A2,Rest1,Rest2),
		random_select(B2,Rest2,Rest3),
		random_select(A3,Rest3,Rest4),
		random_select(B3,Rest4,Rest5),
		random_select(A4,Rest5,Rest6),
		random_select(B4,Rest6,Rest7),
		random_select(A5,Rest7,Rest8),
		random_select(B5,Rest8,Rest9),
		CardsKnowntoPlayer1 = [B1,B2,B3],
		CardsKnowntoPlayer2 = [A1,A2,A3],
		
		A1 = card(A,_R),A2 = card(B,_S),A3 = card(C,_T),A4 = card(D,_U),A5 = card(E,_V),
		CaA = [A,B,C,D,E],
		sort(CaA,CardsA),
		B1 = card(F,_W),B2 = card(G,_X),B3 = card(H,_Y),B4 = card(I,_Z),B5 = card(J,_Q),
		CaB = [F,G,H,I,J],
		sort(CaB,CardsB),

 		write('Player1 Cards are : '),write(CardsInHandForPlayer1),nl,
		write('Player2 cards known to Player 1 : '),write(CardsKnowntoPlayer1),nl,


		write("Lets start the guessing game for Players"),nl,nl,
		delete(Rest6,A5,RemCardsA),
		delete(Rest5,B4,RemCards1),delete(RemCards1,B5,RemCardsB),
		%write(RemCardsA),nl,nl,
		findall([P3,P4],(select(P3,RemCardsA,List2),select(P4,List2,List3)),PairsA),
		length(PairsA,NumPairsA),write('Total Combinations for Player 2 are : '),write(NumPairsA),nl,nl,

		findall([P1,P2],(select(P1,RemCardsB,List4),select(P2,List4,List5)),PairsB),
		length(PairsB,NumPairsB),write('Total Combinations for Player 1 are : '),write(NumPairsB),nl,nl,
		%write(RemCardsB),
		write('******************************************************************Player A Heurisitcs***********************************************'),nl,
		write('Player 1 Detail : '),
		rankguessA(CardsKnowntoPlayer1,PairsA,FreqRankForPlayer2,GRA),nl,nl,
		write(GRA),
		random_select(RankGuessofB,GRA,GRest),
		categoryDecider(RankGuessofB,Cat),
		CatGuessA = Cat,
		write('Rank for Player 1 is :'),classify(CardsInHandForPlayer1,RankForPlayerA),write(RankForPlayerA),nl,
		categoryDecider(RankForPlayerA,Cat),
		CatA = Cat,
		write('Guessed Rank for Player 2 is :'),write(RankGuessofB),nl,nl,



		write('******************************************************************Player B Heurisitcs***********************************************'),nl,
		write('Player 2 Details : '),nl,
		write('Rank for Player 2 is: '),classify(CardsInHandForPlayer2,RankForPlayerB),write(RankForPlayerB),nl,
		categoryDecider(RankForPlayerB,Cat),
		CatB = Cat,
		rankguessB(CardsKnowntoPlayer2,PairsB,FreqRankForPlayer1,RankForPlayerB,GRB),nl,nl,
		write("Player 1 Rank Guessed : "),write(GRB),nl,
		categoryDecider(GRB,Cat),
		CatGuessB = Cat,

		checkplay(CatA,CatGuessA,Decision),
		PlayerADecision = Decision,

		checkplay(CatB,CatGuessB,Decision),
		PlayerBDecision = Decision,
		nl,write('************************************************************Betting Starts Here**********************************'),nl,
		write('Player A decision : -'),write(PlayerADecision),nl,
		write('Player B decision : -'),write(PlayerBDecision),nl,
		BetA = 1, BetB = 1,
		write(CardsA),write(CardsB),
		winpoker(RankForPlayerA,RankForPlayerB,Player,CardsA,CardsB),
		write(Player),
		bettinggame(PlayerADecision,PlayerBDecision,PlayerAChipValue,PlayerBChipValue,PotValue,BetA,BetB,Player,CardsInHandForPlayer1,CardsInHandForPlayer2,ChipAValue,ChipBValue).

winpoker(R1,R2,Player,L1,L2):-
		R1 > R2 -> Player = 'PlayerB';
		R1 < R2 -> Player = 'PlayerA';
		nth1(1,L1,J1),nth1(1,L2,J2),
		J1 > J2 -> Player = 'PlayerA';
		Player = 'PlayerB'.

bettinggame(PAD,PBD ,PAC,PBC,PV,Ab,Bb,Player,CIH1,CIH2,CVA,CVB):-nl,
			compare(=,'quit',PAD) -> write('Player A Folds, Round won by Player B'),
									PBCNew is PBC - Bb + PV,
									PACNew is PAC - Ab + PV,
									PVNew is 0,
									summary(PBCNew, PACNew,PVNew,CIH1,CIH2,CVA,CVB);
			compare(=,'quit',PBD) -> write('Player B Folds, Round won by Player A'),
									PBCNew is PBC - Bb + PV,
									PACNew is PAC - Ab + PV,
									PVNew is 0,
									summary(PBCNew, PACNew,PVNew,CIH1,CIH2,CVA,CVB);
			compare(=,'play',PAD),
			compare(=,'play',PBD) -> equalplayranks(PAC,PBC,PV,Ab,Bb,0,0,Player,CIH1,CIH2,CVA,CVB).
			%compare(=,'alwaysplay',PAD),
			%compare(=,'alwaysplay',PBD) -> alwaysplayranks(PAC,PBC,PV,Ab,Bb,0,1,1);
			%compare(=,'play',PAD),
			%compare(=,'alwaysplay',PBD) -> alwaysplayranksA(PAC,PBC,PV,Ab,Bb,0,1,1);
			%alwaysplayranksB(PAC,PBC,PV,Ab,Bb,0,1,1).

alwaysplay(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,NextbetA,NextbetB):- 
			PAC1 < NextbetB -> alwaysplay1(PAC1,PBC1,PV1,Ab1,Bb1);
			betbyA1(DiffBets,PAC1,nextbetA,Bet),BetA1New = Bet,
			PBC1 > BetA1New -> alwaysplay3(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,NextbetA,NextbetB,BetA1New);
			alwaysplay2(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,NextbetA,NextbetB,BetA1New).

alwaysplay3(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,NextbetA,NextbetB,BetA1New):-
			betbyB1(DiffBets,PBC1,BetA1New,Bet),BetB1New = Bet,
			NewPAC is PAC1 - BetA1New,
			NewPBC is PBC1 - BetB1New,
			NewPotVal is BetA1New + BetB1New,
			alwaysplay(NewPAC,NewPBC,NewPotVal,Ab1,Bb1,DiffBets,BetA1New,BetB1New).

betbyB1(DB,ThresholdMoney,NbA,Bet) :- 
			NbA > 2,
			ThresholdMoney > 2,
			Bet = 3;
			NbA > 1,
			ThresholdMoney > 2,
			random_select(Bet,[2,3],Ra1);
			NbA > 1,
			ThresholdMoney > 1,
			Bet = 2;
			NbA > 0,
			ThresholdMoney > 2,
			random_select(Bet,[1,2,3],Ra1);
			NbA > 0,
			ThresholdMoney > 1,
			random_select(Bet,[1,2],Ra1);
			NbA > 0,
			ThresholdMoney > 0,
			Bet = 1;
			Bet = 0.

alwaysplay1(PAC1,PBC1,PV1,Ab1,Bb1):-
			write('Player 1 is out of money,.... Player 2 wins the game'),
			TotalBVal is PBC1 + PV1,
			summary(PAC1,TotalBVal,0).

alwaysplay2(PAC1,PBC1,PV1,Ab1,Bb1):-
			write('Player 2 is out of money,.... Player 1 wins the game'),
			TotalAVal is PBC1 + PV1,
			summary(PBC1,TotalAVal,0).
		
betbyA1(DB,ThresholdMoney,NbA,NbB,Bet):-
			NbB > 2,
			ThresholdMoney > 2,
			Bet = 3;
			NbB > 1,
			ThresholdMoney > 2,
			random_select(Bet,[2,3],Ra1);
			NbB > 1,
			ThresholdMoney > 1,
			Bet = 2;
			NbB > 0,
			ThresholdMoney > 2,
			random_select(Bet,[1,2,3],Ra1);
			NbB > 0,
			ThresholdMoney > 1,
			random_select(Bet,[1,2],Ra1);
			NbB > 0,
			ThresholdMoney > 0,
			Bet = 1;
			Bet = 0.


			
equalplayranks(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,Time,Player,CIH1,CIH2,CVA,CVB):-
			PAC1 < 1 -> equalplayranks1(PAC1,PBC1,PV1,CIH1,CIH2,CVA,CVB);
			write('Player 1 is betting '),write("  "),
			betbyA(DiffBets,Time,Bet,PAC1),BetANew = Bet,write(BetANew),
			PBC1 > BetANew -> equalplayranks3(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,Player,BetANew,CIH1,CIH2,CVA,CVB);
			equalplayranks2(PAC1,PBC1,PV1,CIH1,CIH2,CVA,CVB).
			

equalplayranks1(PAC1,PBC1,PV1,CIH1,CIH2,CVA,CVB):-
			write('Player 1 is out of money,.... Player 2 wins the game'),
			TotalBVal is PBC1 + PV1,
			summary(0,TotalBVal,0,CIH1,CIH2,CVA,CVB).

equalplayranks2(PAC1,PBC1,PV1,CIH1,CIH2,CVA,CVB):-
			write('Player 2 is out of money,.... Player 1 wins the game'),
			TotalBVal is PBC1 + PV1,
			summary(0,TotalBVal,0,CIH1,CIH2,CVA,CVB).

equalplayranks3(PAC1,PBC1,PV1,Ab1,Bb1,DiffBets,Player,BetANew,CIH1,CIH2,CVA,CVB):-
			TotalBetA is Ab1 + BetANew,write("Total Bet A "), write(TotalBetA),nl,
			PotVal is PV1 + BetANew,write('PotVal : '),write(PotVal),nl,
			write('Player 2 is betting '),write("  "),
			BetBNew is BetANew,write(BetBNew),
			PotVal1 is PotVal + BetBNew, write('PotValNew : '),write(PotVal1),nl,
			TotalBetB is Bb1 + BetANew, write('TotalBetB is : '),write(TotalBetB),nl,
			DiffBets is BetBNew - BetANew, write('DiffBets is : '),write(DiffBets),nl,
			TotalChipValueForA is PAC1 - TotalBetA,
			TotalChipValueForB is PBC1 - TotalBetB,
			write('Player A checks'),nl,write('Player B checks'),nl,write('Show Cards'),nl,
			checkwhowinsandsummarycall(TotalChipValueForA,TotalChipValueForB,PotVal1,Player,CIH1,CIH2,CVA,CVB).


checkwhowinsandsummarycall(TotalChipValueForA,TotalChipValueForB,PotVal1,Player,CIH1,CIH2,CVA,CVB):-
			compare(=,'PlayerA',Player)-> write('Player A wins'),nl,
				TotalChipValueForANew is TotalChipValueForA + PotVal1,
				summary(TotalChipValueForANew,TotalChipValueForB,0,CIH1,CIH2,CVA,CVB);
			write('Player B wins'),nl,write(TotalChipValueForB),
				TotalChipValueForBNew is TotalChipValueForB + PotVal1,
				summary(TotalChipValueForA,TotalChipValueForBNew,0,CIH1,CIH2,CVA,CVB).


betbyA(DB,T,Bet,ThresholdMoney):-
			ThresholdMoney < 1 -> Bet = 0;
			ThresholdMoney < 2 -> Bet =1;
			ThresholdMoney < 3 -> random_select(Bet,[1,2],Ravan1);
			random_select(Bet,[1,2,3],Ravan3).
			

betbyB(DB,T,BetA,Bet):-
			T < 1 -> random_select(Bet,[1,2,3],Ravan);
			DB < 1 -> Bet = 0;
			Bet = DB.		
				

summary(PACV,PBCV,PVF,CIH1,CIH2,CVA,CVB):-
			nl,nl,write('********************Round End Statistics********************'),
			nl,nl,nl,write('Player A Stats are : - '),nl,
			write('Initial Number of Chips with Player 1 : '),write(CVA),nl,
			write('Cards of Player 1 (in order which they were distributed : )'),write(CIH1),nl,
			write('Final Chips Remaining with Player 1 : '), write(PACV),nl,nl,
			write('Player B Stats are : - '),nl,
			write('Initial Number of Chips with Player 2 : '),write(CVB),nl,
			write('Cards of Player 2 (in order which they were distributed : )'),write(CIH2),nl,
			write('Final Chips Remaining with Player 2 : '), write(PBCV),nl,nl,
			PACV < 2 -> write("Game Finished");
			PBCV < 2 -> write("Game Finished");
			playpoker(PACV,PBCV).



checkplay(Actual,Guess,Decision):-
				Actual < Guess -> Decision = 'alwaysplay';
				Actual > Guess -> Decision = 'quit';
				Decision = 'play'.


categoryDecider(X,Cat):-
				member(X,[0,1,2,3]) -> Cat is 1;
				member(X,[4,5,6,7]) -> Cat is 2;
				Cat is 3.


rankguessA(X,Y,FR,GRA):-	
			random_select(G,Y,RestPart),
			append(X,G,GFive),
			classify(GFive,Ranks),%write(Ranks),nl,
			append(FR,[Ranks],FR1),
			rankguessA(X,RestPart,FR1,GRA).


rankguessA(X,[],FR,GRA):-	
			nl,nl,length(FR,L),
			count(FR,0,Count0),count(FR,1,Count1),count(FR,2,Count2),count(FR,3,Count3),count(FR,4,Count4),count(FR,5,Count5),
			count(FR,6,Count6),count(FR,7,Count7),count(FR,8,Count8),count(FR,9,Count9),count(FR,10,Count10),

			CountList = [Count0,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10],
			CountListReplica = [Count0,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10],
			DisplayCountList = [['Rank 0', Count0],['Rank 1', Count1],['Rank 2', Count2],['Rank 3', Count3],['Rank 4', Count4],
			['Rank 5', Count5],['Rank 6', Count6],['Rank 7', Count7],['Rank 8', Count8],['Rank 9', Count9],['Rank 10', Count10]],

			write('Frequency of all Ranks are : '),nl,write(DisplayCountList),nl,nl,

			CPFor0 is div(Count0*10,L)*0.1,CPFor1 is div(Count1*10,L)*0.1,CPFor2 is div(Count2*10,L)*0.1,
			CPFor3 is div(Count3*10,L)*0.1,CPFor4 is div(Count4*10,L)*0.1,CPFor5 is div(Count5*10,L)*0.1,
			CPFor6 is div(Count6*10,L)*0.1,CPFor7 is div(Count7*10,L)*0.1,CPFor8 is div(Count8*10,L)*0.1,
			CPFor9 is div(Count9*10,L)*0.1,CPFor10 is div(Count10*10,L)*0.1, 
			CP = [CPFor0,CPFor1,CPFor2,CPFor3,CPFor4,CPFor5,CPFor6,CPFor7,CPFor8,CPFor9,CPFor10],

			DisplayCPList = [['Rank 0',CPFor0],['Rank 1',CPFor1],['Rank 2',CPFor2],['Rank 3',CPFor3],['Rank 4',CPFor4],
			['Rank 5',CPFor5],['Rank 6',CPFor6],['Rank 7',CPFor7],['Rank 8',CPFor8],['Rank 9',CPFor9],['Rank 10',CPFor10]],

			write('Conditional Probability of each Rank is : '),nl,write(DisplayCPList),nl,
			%delete(CountListReplica,0,NewL),
			%msort(CountListReplica,SortedList1),write(SortedList1),
			
			%delete(SortedList1,0,SortedList),write(SortedList),
			length(SortedList1,LenF),write(LenF),
			%findIndexes(CountListReplica,SortedList,LenF,FinalList),nl,write(FinalList),write("Hey"),
			findmax(CountListReplica,Max1),
			indexOf(CountList,Max1,GR1),
			delete(CountListReplica, Max1,Temp1),

			findmax(Temp1,Max2),
			indexOf(CountList,Max2,GR2),
			delete(Temp1, Max2,Temp2),

			findmax(Temp2,Max3),
			indexOf(CountList,Max3,GR3),

			GRA = [GR1,GR2,GR3].


rankguessB(X2,Y2,FR2,RankForPlayerB,GRB):-	
			random_select(G1,Y2,RestPart1),
			append(X2,G1,GFive1),
			classify(GFive1,Ranks1),%write(Ranks),nl,
			append(FR2,[Ranks1],FR3),
			rankguessB(X2,RestPart1,FR3,RankForPlayerB,GRB).


rankguessB(X2,[],FR2,RankForPlayerB,GRB):-	
			nl,nl,length(FR2,L),
			count(FR2,0,Count0),count(FR2,1,Count1),count(FR2,2,Count2),count(FR2,3,Count3),count(FR2,4,Count4),count(FR2,5,Count5),
			count(FR2,6,Count6),count(FR2,7,Count7),count(FR2,8,Count8),count(FR2,9,Count9),count(FR2,10,Count10),

			CountListB = [Count0,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10],
			CountListReplicaB = [Count0,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10],
			DisplayCountListB = [['Rank 0', Count0],['Rank 1', Count1],['Rank 2', Count2],['Rank 3', Count3],['Rank 4', Count4],
			['Rank 5', Count5],['Rank 6', Count6],['Rank 7', Count7],['Rank 8', Count8],['Rank 9', Count9],['Rank 10', Count10]],

			write('Frequency of all Ranks are : '),nl,write(DisplayCountListB),nl,nl,

			CPFor0 is div(Count0*10,L)*0.1,CPFor1 is div(Count1*10,L)*0.1,CPFor2 is div(Count2*10,L)*0.1,
			CPFor3 is div(Count3*10,L)*0.1,CPFor4 is div(Count4*10,L)*0.1,CPFor5 is div(Count5*10,L)*0.1,
			CPFor6 is div(Count6*10,L)*0.1,CPFor7 is div(Count7*10,L)*0.1,CPFor8 is div(Count8*10,L)*0.1,
			CPFor9 is div(Count9*10,L)*0.1,CPFor10 is div(Count10*10,L)*0.1, 
			CPB = [CPFor0,CPFor1,CPFor2,CPFor3,CPFor4,CPFor5,CPFor6,CPFor7,CPFor8,CPFor9,CPFor10],
			%CountListReplicaB = [CPFor0,CPFor1,CPFor2,CPFor3,CPFor4,CPFor5,CPFor6,CPFor7,CPFor8,CPFor9,CPFor10],

			DisplayCPListB = [['Rank 0',CPFor0],['Rank 1',CPFor1],['Rank 2',CPFor2],['Rank 3',CPFor3],['Rank 4',CPFor4],
			['Rank 5',CPFor5],['Rank 6',CPFor6],['Rank 7',CPFor7],['Rank 8',CPFor8],['Rank 9',CPFor9],['Rank 10',CPFor10]],

			write('Conditional Probability of each Rank is : '),nl,write(DisplayCPListB),nl,
			findmax(CountListReplicaB,MaxB1),
			indexOf(CountListB,MaxB1,GRB1),
			delete(CountListReplicaB, MaxB1, TempB1),

			findmax(TempB1,MaxB2),
			indexOf(CountListB,MaxB2,GRB2),
			delete(TempB1, MaxB2, TempB2),

			findmax(TempB2,MaxB3),
			indexOf(CountListB,MaxB3,GRB3),

			Top1 is div(MaxB1*10,L)*0.1,Top2 is div(MaxB2*10,L)*0.1,Top3 is div(MaxB3*10,L)*0.1,
			TopProbList = [Top1,Top2,Top3],
			GRBTemp = [GRB1,GRB2,GRB3],
			GRB = GRB1.


findmax(L, Max) :- 
			select(Max, L, Rest), \+ (member(E, Rest), E > Max).


indexOf([Element|_], Element, 0).
indexOf([_|Tail], Element, Index):-  	
			indexOf(Tail, Element, Index1),
	  		Index is Index1+1.

count([],X,0).
count([X|T],X,Y):- 
			count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- 
			X1\=X,count(T,X,Z).

								   
%---------------------------------------------------------------
%  flush(X), straight(X), and straightflush(X) 
%      are used to determine whether a
%      hand is a flush, straight or straightflush.
%
%  X is a list of 5 cards.
%---------------------------------------------------------------

flush(X) :-
		nth1(1, X, A),
		nth1(2, X, B),
		nth1(3, X, C),
		nth1(4, X, D),
		nth1(5, X, E),

		A = card(_F, Z),
		B = card(_G, Z),
		C = card(_H, Z),
		D = card(_I, Z),
		E = card(_J, Z).


straight(X) :-
		nth1(1, X, A),
		nth1(2, X, B),
		nth1(3, X, C),
		nth1(4, X, D),
		nth1(5, X, E),

		A = card(F, _K),
		B = card(G, _L),
		C = card(H, _M),
		D = card(I, _N),
		E = card(J, _O),
		Values = [F, G, H, I, J],
		sort(Values, Sorted),
		nth1(1, Sorted, A1),
		nth1(2, Sorted, B1),
		nth1(3, Sorted, C1),
		nth1(4, Sorted, D1),
		nth1(5, Sorted, E1),
		E1 - D1 =:= 1,
		D1 - C1 =:= 1,
		C1 - B1 =:= 1,
		B1 - A1 =:= 1.
		

straightflush(X) :-
		straight(X),
		flush(X).

%---------------------------------------------------------------
%  comparecards(N, A, B, C, D, E) is used to compare 
%  the numbers on cards to each other and 
%  thus classify them into one pair, two pair, three of a kind,
%  full house, four of a kind or nothing.
%
%  N is the number of unique numbers in the list of cards; 
%  A, B, C, D, and E are the actual numbers.
%---------------------------------------------------------------

comparecards(N, A, B, C, D, E, I) :-

		N = 4 -> I = 8;
		%format('One Pair ~n');

		N =:= 3,
		A =:= B,
		B =:= C -> I=6;
		%format('Three of a Kind ~n');

		N =:= 3,		
		B =:= C,
		C =:= D -> I=6;
		%format('Three of a Kind ~n');

		N =:= 3,
		C =:= D,
		D =:= E -> I=6;
		%format('Three of a Kind ~n');

		N =:= 3 -> I=7;
		%format('Two Pair ~n');

		N =:= 2,
		A =:= B,
		B =:= C,
		D =:= E -> I=3;
		%format('Full House ~n');

		N =:= 2,
		A =:= B,
		C =:= D,
		D =:= E -> I=3;
		%format('Full House ~n');

		N =:= 2 -> I=2;
		%format('Four of a Kind ~n');
		
		N =:= 1 -> I=0;
		%format('Five of a Kind ~n');

		I=10. %format('Nothing ~n').

%-------------------------------------------------------------
%  prep(X) is the function that prepares for the call to 
%  comparecards.  It enumberates the cards from the list.  
%  Then it extracts the components of each card.  
%  It uses sort(Y, Sorted) to remove duplicates in the list.
%  msort creats a sorted list with duplicates.  
%  length tells us how many unique numbers are in the list.
%  nth1 enumerates the list in to seperate variables.
%  Then comparecards is called.
%
%  X is a list of 5 cards.
%---------------------------------------------------------------

prep(X, _I) :-
		nth1(1, X, A),
		nth1(2, X, B),
		nth1(3, X, C),
		nth1(4, X, D),
		nth1(5, X, E),

		A = card(F, _R),
		B = card(G, _S),
		C = card(H, _T),
		D = card(I, _U),
		E = card(J, _V),

		Y = [F, G, H, I, J],

		sort(Y, Sorted),
		msort(Y, SortedM),
		length(Sorted, Q),
		nth1(1, SortedM, K),
		nth1(2, SortedM, L),
		nth1(3, SortedM, M),
		nth1(4, SortedM, N),
		nth1(5, SortedM, P),

		comparecards(Q, K, L, M, N, P, _I).
		
%---------------------------------------------------------------
%  classify(X) is the main classification function.  
%  It simply calls other rules and outputs the results.
%
%  X is a list of 5 cards.
%---------------------------------------------------------------

classify(X,I) :-
		straightflush(X) -> I = 1;
		%format('Straight Flush Rank 1 ~n');
		flush(X) -> I=4;
		%format('Flush Rank 4 ~n');
		straight(X) -> I=5;
		%format('Straight Rank 5 ~n');
		prep(X,I).


