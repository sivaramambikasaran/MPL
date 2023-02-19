#!/usr/bin/perl
use POSIX;

my @player = ("AS","AT","GB","KN","KR","PJ","SA","SK","SS","SV");
my %playerCurrentRating;
my %playerGames;
my %playerWins;
my %playerWinPercent;
my %playerPointsWon;
my %playerPointsLost;
my %playerAveragePointsWon;
my %playerAveragePointDiff;

open(DATA, "<data.txt");
my @data = <DATA>;
close (DATA);

# Elo parameters
my $K=20; my $alpha = 10;

sub getCurrentRating {
	open(RAT, "<output/ratings.txt");
	my @ratings = <RAT>;
	close (RAT);
	
	my $lastRatingLine = $ratings[$#ratings];
	my @currentRating = split(" ",$lastRatingLine);
	
	for (my $i=0; $i< @player; $i++) {
		$playerCurrentRating{$player[$i]} = $currentRating[$i];
	}
}


foreach (@player) {
	my $playerName = $_;
	open(FH, ">output/data_$_.txt");
	foreach (@data) {
		if ($_=~/$playerName/) {
			print FH $_;
		}
		else {
			print FH "\n";
		}
	}
	close (FH);
}

sub initialise() {
	
	foreach (@player) {
		$playerCurrentRating{$_}	= 1500;
		$playerGames{$_} 			= 0;
		$playerWins{$_} 			= 0;
		$playerWinPercent{$_}		= 0;
		$playerPointsWon{$_}		= 0;
		$playerPointsLost{$_}		= 0;
		$playerAveragePointsWon{$_}	= 0;
		$playerAveragePointDiff{$_}	= 0;
	}
	open(RAT,">output/ratings.txt");
	open(GAMES,">output/games.txt");
	open(WIN,">output/wins.txt");
	open(WP,">output/winpercent.txt");
	open(S,">output/scored.txt");
	open(C,">output/conceded.txt");
	open(APW,">output/apw.txt");
	open(APD,">output/apd.txt");

	foreach (@player) {
		print RAT $_, "\t";
		print GAMES $_, "\t";
		print WIN $_, "\t";
		print WP $_, "\t";
		print S $_, "\t";
		print C $_, "\t";
		print APW $_, "\t";
		print APD $_, "\t";
		}
	print RAT "\n";
	print GAMES "\n";
	print WIN "\n";
	print WP "\n";
	print S "\n";
	print C "\n";
	print APW "\n";
	print APD "\n";

	foreach (@player) {
		 print RAT $playerCurrentRating{$_}, "\t";
		 print GAMES $playerGames{$_}, "\t";
		 print WIN $playerWins{$_}, "\t";
		 print WP $playerWinPercent{$_}, "\t";
		 print S $playerPointsWon{$_}, "\t";
		 print C $playerPointsLost{$_}, "\t";
		 print APW $playerAveragePointsWon{$_}, "\t";
		 print APD $playerAveragePointDiff{$_}, "\t";
	}
	close(RAT);
}

sub getEloChange {
	my ($wAvg, $lAvg, $loserscore) = @_; 

	# $eloChange = 1-$loserscore/100;
	
	# $eloChange = 1.0;
	
	$eloChange = exp(-$loserscore/20);

	if ($wAvg > $lAvg) {
		$eloChange *= $K/2*exp(-($wAvg-$lAvg)/($alpha*$K));
	}
	else {
		$eloChange *= ($K - $K/2*exp(($wAvg-$lAvg)/($alpha*$K)));
	}
	return $eloChange;
}

sub updateRating {
	my ($game) = @_;
	getCurrentRating();
	
	my @igame = split(" ",$game);

	my @winners = ($igame[0],$igame[1]);
	my @losers = ($igame[2],$igame[3]);

	my $winnerAvg = 0.5*($playerCurrentRating{$winners[0]}+$playerCurrentRating{$winners[1]});
	my $loserAvg = 0.5*($playerCurrentRating{$losers[0]}+$playerCurrentRating{$losers[1]});

	my $eloChange = getEloChange($winnerAvg,$loserAvg,$igame[4]);
	
	foreach (@winners) {
		$playerCurrentRating{$_} += $eloChange;
		$playerGames{$_}+=1;
		$playerWins{$_} +=1;
		$playerWinPercent{$_}=($playerWins{$_}*100.0)/$playerGames{$_};
		$playerPointsLost{$_}+=$igame[4];
		if ($igame[4]>18) {
			$playerPointsWon{$_}+=($igame[4]+2);
		}
		else {
			$playerPointsWon{$_}+=21;
		}
		$playerAveragePointsWon{$_} = $playerPointsWon{$_}/$playerGames{$_};
		$playerAveragePointDiff{$_} = ($playerPointsWon{$_}-$playerPointsLost{$_})/$playerGames{$_};
	}
	foreach (@losers) {
		$playerCurrentRating{$_} -= $eloChange;
		$playerGames{$_}+=1;
		$playerWinPercent{$_}=floor($playerWins{$_}/$playerGames{$_}*100);
		$playerPointsWon{$_}+=$igame[4];
		if ($igame[4]>18) {
			$playerPointsLost{$_}+=($igame[4]+2);
		}
		else {
			$playerPointsLost{$_}+=21;
		}
		$playerAveragePointsWon{$_} = $playerPointsWon{$_}/$playerGames{$_};
		$playerAveragePointDiff{$_} = ($playerPointsWon{$_}-$playerPointsLost{$_})/$playerGames{$_};
	}

	open(RAT, ">>output/ratings.txt");
	print RAT "\n";
	foreach (@player) {
		print RAT $playerCurrentRating{$_},"\t";
	}
	close RAT;

	open(GAMES, ">>output/games.txt");
	print GAMES "\n";
	foreach (@player) {
		print GAMES $playerGames{$_},"\t";
	}
	close GAMES;

	open(WINS, ">>output/wins.txt");
	print WINS "\n";
	foreach (@player) {
		print WINS $playerWins{$_},"\t";
	}
	close WINS;

	open(WP, ">>output/winpercent.txt");
	print WP "\n";
	foreach (@player) {
		print WP $playerWinPercent{$_},"\t";
	}
	close WP;

	open(PW, ">>output/scored.txt");
	print PW "\n";
	foreach (@player) {
		print PW $playerPointsWon{$_},"\t";
	}
	close PW;

	open(PL, ">>output/conceded.txt");
	print PL "\n";
	foreach (@player) {
		print PL $playerPointsLost{$_},"\t";
	}
	close PL;

	open(APW, ">>output/apw.txt");
	print APW "\n";
	foreach (@player) {
		print APW $playerAveragePointsWon{$_},"\t";
	}
	close APW;

	open(APD, ">>output/apd.txt");
	print APD "\n";
	foreach (@player) {
		print APD $playerAveragePointDiff{$_},"\t";
	}
	close APD;
}

initialise();
foreach(@data) {
	updateRating ($_);
}