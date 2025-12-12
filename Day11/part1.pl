#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my %input;
my %cache;

# aaa: you hhh
while (<>) {
	chomp;
	my ($src, $dstStr) = split /: /;
	my @dst = split / /, $dstStr;
	$input{$src} = \@dst
}

$total = countPaths("you");

# Print solution
print "Solution: $total\n";


sub countPaths {
	my $node = shift;
	return 1 if ($node eq "out");
	return $cache{$node} if (exists $cache{$node});

	my @paths = @{$input{$node}};
	my $val = 0;
	foreach my $path (@paths) {
		$val += countPaths($path);
	}
	$cache{$node} = $val;
	return $val;
}
