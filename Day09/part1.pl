#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my @input;

while (<>) {
	chomp;
	push @input, [split /,/];
}

my @sortedInput;
# sort as copy, by X value

foreach my $i (0 .. $#input-1) {
	my ($ax, $ay) = @{$input[$i]};
	foreach my $j ($i+1 .. $#input) {
		my ($bx, $by) = @{$input[$j]};
		my $w = abs($ax - $bx) + 1;
		my $h = abs($ay - $by) + 1;
		my $area = $w * $h;
		$total = $area if ($area > $total);
	}
}

# Print solution
print "Solution: $total\n";
