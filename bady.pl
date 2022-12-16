#!/usr/bin/perl
use POSIX;

my @player = ("AS","AT","GB","KN","KR","PJ","SA","SK","SS","SV");
my %playerCurrentRating;
my %playerGames;
my %playerWins;
my %playerWinPercent;
my %playerPointsWon;
my %playerPointsLost;

open(DATA, "<data.txt");
my @data = <DATA>;
close (DATA);

# Elo parameters
my $K=20; my $alpha = 3;

sub getCurrentRating (){
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
	open(RAT,">output/ratings.txt");

	foreach (@player) {
		print RAT $_, "\t\t";
		}
	print RAT "\n";
	foreach (@player) {
		 print RAT "1500\t";
	}
	close(RAT);
	
	open(GAMES,">output/games.txt");
	foreach (@player) {
		print GAMES $_, "\t";
		}
	print GAMES "\n";
	foreach (@player) {
		 print GAMES "0\t";
	}
	close(GAMES);
	
	open(WIN,">output/wins.txt");
	foreach (@player) {
		print WIN $_, "\t";
		}
	print WIN "\n";
	foreach (@player) {
		 print WIN "0\t";
	}
	close(WIN);
	
	open(WP,">output/winpercent.txt");
	foreach (@player) {
		print WP $_, "\t";
		}
	print WP "\n";
	foreach (@player) {
		 print WP "0\t";
	}
	close(WP);
}

sub getEloChange {
	my ($wAvg, $lAvg, $loserscore) = @_; 

	$eloChange = 1-$loserscore/100;
	
	# $eloChange = 1.0;
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
		$playerWins{$_} +=1;
		$playerGames{$_}+=1;
		$playerWinPercent{$_}=($playerWins{$_}*100)/$playerGames{$_};
	}
	foreach (@losers) {
		$playerCurrentRating{$_} -= $eloChange;
		$playerGames{$_}+=1;
		$playerWinPercent{$_}=floor($playerWins{$_}/$playerGames{$_}*100);
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
}

initialise();
foreach(@data) {
	updateRating ($_);
}