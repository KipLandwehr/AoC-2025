#!/usr/bin/perl
use warnings;
use strict;

#use File::Basename qw(dirname);
#use Cwd qw(abs_path);
#use lib dirname(dirname abs_path $0);
#use My::AoC::Helper qw(coordValid getDirOffsetCoord getNeighbors wrapCoord);

my $debug = 0;
my $total = 0;

# Input separator
# $/ = "\n";
while (<>) {
	chomp;
	my @digits = split //;

	my $firstDigit = $digits[0];
	my $firstIndex = 0;

	# Find first occurance of max value that is not in the last index of the array of digits
	foreach my $i (1 .. $#digits-1) {
		if ($digits[$i] > $firstDigit) {
			$firstDigit = $digits[$i];
			$firstIndex = $i;
		}
	}

	# Find second-max value to the right of the previous max
	my $secondIndex = $firstIndex + 1;
	my $secondDigit = $digits[$secondIndex];

	foreach my $i ($firstIndex+2 .. $#digits) {
		if ($digits[$i] > $secondDigit) {
			$secondDigit = $digits[$i];
			$secondIndex = $i;
		}
	}

	my $joltage = int($firstDigit . $secondDigit);
	$total += $joltage;
}

# Print solution
print "Solution: $total\n";
