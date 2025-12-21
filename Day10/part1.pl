#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

while (<>) {
	chomp;
	# [##...#] (1,3,4,5) (2,3,5) (0,2,3) (0,2,3,4,5) (1,2,4) (0,1,2,3) {24,27,40,30,25,17}
	my ($lightStr, $buttonStr, $joltageStr) = $_ =~ m/^\[(.*)\] (.*) \{(.*)\}$/;
	$lightStr =~ tr/.#/01/;
	my @lights = (split //, $lightStr);
	my @joltages = (split /,/, $joltageStr);

	my @buttonStrs = split /\) \(/, substr($buttonStr, 1, -1);
	my @buttons;
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

	my $stop = 0;
	my $presses = 0;
	until ($stop or ($presses > @buttons)) {
		$stop = checkCombos(++$presses, \@lights, \@buttons);
	} 
	if ($stop == 0) {
		print "Expected presses exceeded at line $.\n";
	}

	$total += $presses;
}

# Print solution
print "Solution: $total\n";

sub checkCombos {
	my $presses = shift;
	my @target = @{ shift @_ };
	my @buttons = @{ shift @_ };
	if ($presses == 1) {
		# Check if any button matches the target exactly
		BUTTON: foreach my $i (0 .. $#buttons) {
			my @button = @{$buttons[$i]};
			# Check each element of the button against the target
			foreach my $j (0 .. $#button) {
				next BUTTON unless ($button[$j] == $target[$j]);
			}
			return 1;
		}
	}
	else {
		#check combinations of buttons
		foreach my $i (0 .. @buttons-$presses) {
			my @b1 = @{$buttons[$i]};
			my @newTarget;
			foreach my $j (0 .. $#target) {
				my $op1 = $target[$j];
				my $op2 = $b1[$j];
				my $newVal;
				# XOR Ops
				$newVal = 0 if ($op1 == $op2);
				$newVal = 1 if ($op1 != $op2);
				$newTarget[$j] = $newVal;
			}
			my @subA;
			my $k = 0;
			foreach my $l ($i .. $#buttons) {
				$subA[$k] = $buttons[$l];
				$k++;
			}
			return 1 if (checkCombos($presses-1, \@newTarget, \@subA));
		}
	}
	return 0;
}

