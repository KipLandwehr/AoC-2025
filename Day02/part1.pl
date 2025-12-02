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
$/ = ',';

while (<>) {
	chomp;
	my ($min, $max) = split '-';

	my $val = $min;
	while ($val <= $max) {
		my $len = length($val);
		if ($len%2 == 1) {
			# if odd length, skip ahead to next power of 10 with even length
			$val = 10 ** $len;
			last if ($val > $max);
		}
		else {
			my $div = ( 10 ** ($len/2) + 1);
			if ( $val % $div == 0 ) {
				$total += $val;
			}
			$val++;
		}
	}
}

# Print solution
print "Solution: $total\n";
