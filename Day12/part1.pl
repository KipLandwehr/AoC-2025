#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

# Input separator
$/ = "\n\n";

my @input;

while (<>) {
	chomp;
	push @input, $_;
}

my $treeStr = pop @input;
my @trees = split /\n/, $treeStr;
my %packs;

my $i = 0;
while (@input) {
	my $str = shift @input;
	my @lines = split /\n/, $str;
	my $num = shift @lines;
	my $blocks = 0;
	while (@lines) {
		$blocks += grep(/#/, split //, shift @lines);
	}
	$packs{$i} = $blocks;
	$i++;
}

foreach my $tree (@trees) {
	my ($dimens, $shapeStr) = split /: /, $tree;
	my ($w, $h) = split /x/, $dimens;
	my @shapes = split / /, $shapeStr;

	my $regA = $w * $h;

	my $minPackA = 0;
	foreach my $s (0 .. $#shapes) {
		$minPackA += $packs{$s} * $shapes[$s];
	}

	my $maxPackA = 0;
	for (@shapes) {
		$maxPackA += 9 * $_;
	}

	if ($maxPackA <= $regA ) {
		$total++;
	}
	elsif ($minPackA > $regA) {
		# instant no
	}
	else {
		print "$tree\n";
	}
}

# Print solution
print "Solution: $total\n";

