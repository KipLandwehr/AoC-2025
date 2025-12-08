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

$total = followPath(0, $scol);

# Print solution
print "Solution: $total\n";

sub followPath {
	my ($r, $c) = @_;
	my $in = $input[$r][$c];
	while (($r < $#input) and ($in eq 'S' or $in eq '.')) {
		$in = $input[++$r][$c];
	}
	return 1 if ($r == $#input);
	if ($in eq '^') {
		if ($splitters{"$r,$c"}) {
			return $splitters{"$r,$c"};
		}
		$splitters{"$r,$c"} = followPath($r,$c-1);
		$splitters{"$r,$c"} += followPath($r,$c+1);
	}
	else {
		print "invalid input at $r, $c\n";
	}
}
