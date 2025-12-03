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
	my @cells = split //;

	my @digits;
	foreach my $d (0..11) {
		# Find first occurance of max value that is right of previously found digit
		# and not in the last 12-($d+1) indicies of the array of cells

		# Initialize starting point
		my $max;
		my $index;

		if ($d == 0) {
			$index = 0;
			$max = $cells[$index];
		}
		else {
			$index = $digits[$d-1][1] + 1;	# start at one more than the previous digit's index
			$max = $cells[$index];
		}

		my $iLimit = scalar(@cells) - (12 - $d);

		foreach my $i ($index+1..$iLimit) {
			if ($cells[$i] > $max) {
				$max = $cells[$i];
				$index = $i;
			}
		}
		push @digits, [$max, $index];
	}

	my $joltage = 0;
	foreach my $digit (0..$#digits) {
		$joltage *= 10;
		$joltage += $digits[$digit][0];
	}

	$total += $joltage;
}

# Print solution
print "Solution: $total\n";
