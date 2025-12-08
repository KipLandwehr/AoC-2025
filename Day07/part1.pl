#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my @input;

while (<>) {
	chomp;
	push @input, [split //];
}

my %splitters;

# get S location
my $scol = $#{$input[0]} / 2;

followPath(0, $scol);

$total = keys %splitters;

# Print solution
print "Solution: $total\n";

sub followPath {
	my ($r, $c) = @_;
	my $in = $input[$r][$c];
	while (($r < $#input) and ($in eq 'S' or $in eq '.')) {
		$in = $input[++$r][$c];
	}
	return if ($r == $#input);
	if ($in eq '^') {
		if ($splitters{"$r,$c"}) {
			return;
		}
		followPath($r,$c-1);
		followPath($r,$c+1);
		$splitters{"$r,$c"}++;
	}
	else {
		print "invalid input at $r, $c\n";
	}
}
