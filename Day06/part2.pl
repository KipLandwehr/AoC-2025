#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my @input;

while (<>) {
	chomp;
	my @line = split //;

	foreach my $i (0 .. $#line) {
		if ($input[$i]) {
			push @{$input[$i]}, $line[$i];
		}
		else {
			$input[$i] = [$line[$i]];
		}
	}
}

my $ans = 0;
my $op;
my $getOp = 0;

while (@input) {
	my @line = @{shift @input};

	if ($getOp == 0) {
		$op = pop @line;
		$getOp = 1;
	}
	
	my $str = shift @line;
	while (@line) {
		$str .= shift @line;
	}

	if ($str =~ /^ *$/) {
		$total += $ans;
		$ans = 0;
		$getOp = 0;
	}
	else {
		my $val = int $str;
		if ($ans == 0) {
			$ans = $val;
		}
		else {
			$ans += $val if ($op eq '+');
			$ans *= $val if ($op eq '*');
		}
	}
}
$total += $ans;

# Print solution
print "Solution: $total\n";
