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
$/ = "\n\n";

my $ranges = <>;
chomp $ranges;

my %freshIDs;
my @keys;

foreach my $range (split "\n", $ranges) {
	chomp $range;
	my ($min, $max) = split '-', $range;
	#print "$min-$max\n";
	if ($freshIDs{$min}) {
		$freshIDs{$min} = (sort { $a <=> $b } ($max, $freshIDs{$min}))[1];
	}
	else {
		$freshIDs{$min} = $max;
		push @keys, $min;
	}
}

my @sortedKeys = sort { $a <=> $b } @keys;
#foreach my $i (0 .. $#sortedKeys) {
#	print "$sortedKeys[$i], ";
#}
#print "\n";

my %mergedRanges;

my $i = 0;
while ($i <  @sortedKeys) {
	my $min = $sortedKeys[$i];
	my $max = $freshIDs{$min};
	#print "$min..$max\n";

	my $j = $i + 1;
	#print "next min: $sortedKeys[$j]\n" if ($j < @sortedKeys);
	while ($j < @sortedKeys and $max >= $sortedKeys[$j]) {
		#print "Entered merge ... \n";
		# while there are ranges left to check AND max is greater than the low end of the next range
		# there's an overlap, so update max to the greater of the two maxes
		$max = (sort { $a <=> $b } ($max, $freshIDs{$sortedKeys[$j]}))[1];
		# and increment j to check for overlap on the next range
		$j++;
	}
	
	# Should now have the min and max of the current set of overlapping ranges
	# Store them
	#print "Merged range: $min - $max\n";
	$mergedRanges{$min} = $max;

	# update i to start at next range (which we just checked and didn't overlap, and starts the next range)
	$i = $j;
}

# count total items
foreach my $key (keys %mergedRanges) {
	#print "$key-$mergedRanges{$key}\n";
	my $num = ($mergedRanges{$key} - $key) + 1;
	$total += $num;
}

# Print solution
print "Solution: $total\n";
