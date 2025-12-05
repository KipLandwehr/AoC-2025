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
my $values = <>;

chomp $ranges;
chomp $values;

my %freshIDs;
my @keys;

foreach my $range (split "\n", $ranges) {
	chomp $range;
	my ($min, $max) = split '-', $range;
	#print "$min-$max\n";
	if ($freshIDs{$min}) {
		$freshIDs{$min} = (sort ($max, $freshIDs{$min}))[1];
	}
	else {
		$freshIDs{$min} = $max;
		push @keys, $min;
	}
}

#foreach my $i (0 .. $#keys) {
#	print "$keys[$i]-$freshIDs{$keys[$i]}\n";
#}
#print "\n";

my @sortedKeys = sort(@keys);

VAL: foreach my $value (split "\n", $values) {
	chomp $value;
	#print "$value\n";
	foreach my $key (@sortedKeys) {
		if ($value >= $key and $value <= $freshIDs{$key}) {
			$total++;
			next VAL;
		}
	}
}

# Print solution
print "Solution: $total\n";
