#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

# Input separator
$/ = "\n\n";

my $ranges = <>;
chomp $ranges;

my %freshIDs;
my @keys;

foreach my $range (split "\n", $ranges) {
	chomp $range;
	my ($min, $max) = split '-', $range;
	if ($freshIDs{$min}) {
		$freshIDs{$min} = (sort { $a <=> $b } ($max, $freshIDs{$min}))[1];
	}
	else {
		$freshIDs{$min} = $max;
		push @keys, $min;
	}
}

my @sortedKeys = sort { $a <=> $b } @keys;
my %mergedRanges;

my $i = 0;
while ($i <  @sortedKeys) {
	my $min = $sortedKeys[$i];
	my $max = $freshIDs{$min};

	my $j = $i + 1;
	while ($j < @sortedKeys and $max >= $sortedKeys[$j]) {
		# while there are ranges left to check AND max is greater than the low end of the next range
		# there's an overlap, so update max to the greater of the two maxes
		$max = (sort { $a <=> $b } ($max, $freshIDs{$sortedKeys[$j]}))[1];
		# and increment j to check for overlap on the next range
		$j++;
	}
	
	# Should now have the min and max of the current set of overlapping ranges
	# Store them
	$mergedRanges{$min} = $max;

	# update i to start at next range (which we just checked and didn't overlap, and starts the next range)
	$i = $j;
}

# count total items
foreach my $key (keys %mergedRanges) {
	my $num = ($mergedRanges{$key} - $key) + 1;
	$total += $num;
}

# Print solution
print "Solution: $total\n";
