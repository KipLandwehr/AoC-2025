#!/usr/bin/perl
use warnings;
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname abs_path $0);
use My::AoC::Helper qw(coordValid getDirOffsetCoord getNeighbors getOrthoNeighbors wrapCoord);

my $debug = 0;
my $total = 0;

my @input;

while (<>) {
	chomp;
	push @input, [split //];
}

my $changed = 1; # start off assuming you might be able to remove rolls
while ($changed) {
	$changed = 0;
	foreach my $r (0 .. $#input) {
		foreach my $c (0 .. $#{$input[$r]}) {
			next if ($input[$r][$c] eq '.');
			
			my $adjacentRolls = 0;

			my @neighbors = getNeighbors($r, $c);
			while (@neighbors) {
				my ($nr, $nc) = @{shift @neighbors};
				next unless coordValid([$nr, $nc], \@input);
				$adjacentRolls++ if ($input[$nr][$nc] eq "@");
			}

			if ($adjacentRolls < 4) {
				$input[$r][$c] = '.';
				$total++;
				$changed = 1;
			}
		}
	}
}

# Print solution
print "Solution: $total\n";
