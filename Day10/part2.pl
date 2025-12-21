#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my @buttons;
my %cache;
my %parityCache;

while (<>) {
	chomp;
	my ($lightStr, $buttonStr, $joltageStr) = $_ =~ m/^\[(.*)\] (.*) \{(.*)\}$/;
	$lightStr =~ tr/.#/01/;
	my @lights = (split //, $lightStr);

	my @buttonStrs = split /\) \(/, substr($buttonStr, 1, -1);

	@buttons = ();
	foreach my $i (0 .. $#buttonStrs) {
		my $str = $buttonStrs[$i];
		my @button = split /,/, $str;

		my @tmp;
		foreach my $j (0 .. $#lights) {
			$tmp[$j] = 0;
		}
		foreach my $j (0 .. $#button) {
			my $l = $button[$j];
			$tmp[$l] = 1;
		}
		push @buttons, \@tmp;
	}

	%cache = ();
	%parityCache = ();
	my $count += getCount($joltageStr);
	$total += $count;
}

# Print solution
print "Solution: $total\n";

sub getCount {
	my $joltageStr = shift @_;

	if (exists $cache{$joltageStr}) {
		return $cache{$joltageStr};
	}

	my @joltages = (split /,/, $joltageStr);

	my $allZero = 1;
	my $allEven = 1;
	my $someNegative = 0;
	foreach my $i (0 .. $#joltages) {
		if ($joltages[$i] != 0) {
			$allZero = 0;
		}
		if ($joltages[$i] % 2 == 1) {
			$allEven = 0;
		}
		if ($joltages[$i] < 0) {
			$someNegative = 1;
		}
	}

	# if all joltages are 0, return 0
	if ($allZero) {
		$cache{$joltageStr} = 0;
		return 0;
	}
	# if some joltages are negavive, return high value
	elsif ($someNegative) {
		$cache{$joltageStr} = 1_000_000;
		return 1_000_000;
	}
	# if all values are even, halve them, then get the count of the reduction
	elsif ($allEven) {
		my @newJoltages;
		foreach my $i (0 .. $#joltages) {
			$newJoltages[$i] = $joltages[$i]/2;
		}
		my $newJoltStr;
		foreach my $i (0 .. $#newJoltages) {
			$newJoltStr .= "$newJoltages[$i],";
		}
		$newJoltStr = substr($newJoltStr,0,-1);	#remove trailing comma
		my $count += 2 * getCount($newJoltStr);
		$cache{$joltageStr} = $count;
		return $count;
	}
	# some values are odd
	else {
		#calculate parity
		my $parity;
		foreach my $i (0 .. $#joltages) {
			if ($joltages[$i] % 2 == 0) {
				$parity .= "0";
			}
			else {
				$parity .= "1";
			}
		}

		#get button combos for parity
		my @combos = getCombos($parity);
		if (scalar @combos == 0) {
			# this parity cannot be obtained, so return "infinte" (aka very high) cost
			$cache{$joltageStr} = 1_000_000;
			return 1_000_000;
		}

		my $minCount = 1_000_000;
		COMBO: foreach my $i (0 .. $#combos) {
			# calculate remaining joltages
			my $count = 0;
			my @c = split //, $combos[$i];
			my @remJolts = @joltages;
			foreach my $j (0 .. $#c) {
				if ($c[$j] == 1) {
					$count++;
					foreach my $k (0 .. @{$buttons[$j]}-1) {
						$remJolts[$k]-- if ($buttons[$j][$k] == 1);
						next COMBO if ($remJolts[$k] < 0);
					}
				}
			}
			my $remJoltStr;
			foreach my $j (0 .. $#remJolts) {
				$remJoltStr .= "$remJolts[$j],";
			}
			$remJoltStr = substr($remJoltStr,0,-1);	#remove trailing comma

			# get count for remaining joltages
			$count += getCount($remJoltStr);
			$minCount = $count if ($count < $minCount);
		}
		# cache
		$cache{$joltageStr} = $minCount;
		return $minCount;
	}
}

sub getCombos {
	my $parity = shift @_;

	if (exists $parityCache{$parity}) {
		return @{$parityCache{$parity}};
	}

	my $comboCount = 2 ** @buttons;
	my @comboList = ();
	my $formatting = "%0" . scalar @buttons . "b";
	foreach my $i (1 .. $comboCount-1) {
		my $bStr = sprintf("$formatting", $i);
		my @bArr = split //, $bStr;

		my @par;
		foreach my $j (0 .. length($parity)-1) {
			$par[$j] = 0;
		}
		
		# @bArr contains a list of which buttons to combine and check
		# foreach index that is 1, get the button, and XOR with @par
		foreach my $j (0 .. $#bArr) {
			if ($bArr[$j] == 1) {
				my @button = @{ $buttons[$j] };
				foreach my $k (0 .. $#button) {
					if ($button[$k] == $par[$k]) {
						$par[$k] = 0;
					}
					else {
						$par[$k] = 1;
					}
				}
			}
		}
		# if the concatination of @par == $parity, then record the button list
		my $testPar;
		foreach my $j (0 .. $#par) {
			$testPar .= $par[$j];
		}
		if ($parity == $testPar) {
			push @comboList, $bStr;
		}
	}
	@{$parityCache{$parity}} = @comboList;
	return @comboList;
}

