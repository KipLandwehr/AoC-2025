#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

# connection count
#my $cc = 10;	# test input
my $cc = 1000;	# real input

my @input;

while (<>) {
	chomp;
	push @input, [split /,/];
}

my %distances;
foreach my $i (0 .. $#input-1) {
	my ($ax, $ay, $az) = @{$input[$i]};
	foreach my $j ($i+1 .. $#input) {
		my ($bx, $by, $bz) = @{$input[$j]};
		my $delta = (($ax-$bx) ** 2) + (($ay-$by) ** 2) + (($az-$bz) ** 2);
		push @{$distances{$delta}}, [$i, $j];
	}
}

my @sortedDists = sort { $a <=> $b } (keys %distances);

my %nodes;
my $cID = 1;

my $count = 0;
while ($count < $cc) {
	my $dist = shift @sortedDists;
	my @pairs = @{$distances{$dist}};
	while (@pairs) {
		$count++;
		my ($a, $b) = @{shift @pairs};
		if ($nodes{$a} and $nodes{$b}) {
			# Merge circuits, if needed
			if ($nodes{$a} != $nodes{$b}) {
				my $update = $nodes{$b};
				foreach my $k (keys %nodes) {
					if ($nodes{$k} == $update) {
						$nodes{$k} = $nodes{$a};
					}
				}
			}
		}
		elsif ($nodes{$a}) {
			# Add $b to circuit containing $a
			$nodes{$b} = $nodes{$a};
		}
		elsif ($nodes{$b}) {
			# Add $a to circuit containing $b
			$nodes{$a} = $nodes{$b};
		}
		else {
			# Create new circuit with $a and $b
			$nodes{$a} = $cID;
			$nodes{$b} = $cID;
			$cID++;
		}
	}
}

my %circuits;
foreach my $k (sort keys %nodes) {
	# key on cID, count number of nodes for the cID
	$circuits{$nodes{$k}}++;
}

my @cirLens;
foreach my $cir (sort keys %circuits) {
	push @cirLens, $circuits{$cir};
}

my @sortedCirLens = reverse sort { $a <=> $b } @cirLens;

$total = shift @sortedCirLens;
foreach (1..2) {
	$total *= (shift @sortedCirLens);
}

# Print solution
print "Solution: $total\n";
