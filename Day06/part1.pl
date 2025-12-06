#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my @probs;

while (<>) {
	chomp;
	$_ =~ s/^\s+|\s+$//g;
	my @line = split /\s+/;

	foreach my $i (0 .. $#line) {
		if ($probs[$i]) {
			push @{$probs[$i]}, $line[$i];
		}
		else {
			$probs[$i] = [$line[$i]];
		}
	}
}

while (@probs) {
	my @prob = @{shift @probs};
	my $op = pop @prob;
	my $ans = shift @prob;
	while (@prob) {
		my $val = shift @prob;
		$ans += $val if ($op eq '+');
		$ans *= $val if ($op eq '*');
	}
	$total += $ans;
}

# Print solution
print "Solution: $total\n";
