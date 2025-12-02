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
# $/ = "\n";

my $wheel = 50;		# wheel value starts at 50

while (<>) {
	chomp;
	my ($op, $val) = m/([LR])(\d+)/;

	$total += int($val/100);	# any full rotation will pass 0 one time
	$val %= 100;			# get remainder of value to check for additional 0 pass/land

	next if ($val == 0);
	# If we have no rotation left to do, we don't need to update $wheel or do any additional checks
	# Also avoids an edge-case where we started on 0, counted all full-rotations, including the last one that stops at 0, then counting the ending on zero again

	if ($op eq 'L') {
		$total-- if ($wheel == 0);
		# If we start at 0, we'll end negative, but we haven't *passed* 0, only moved off of it
		# So, decrement now, and we'll add it back when we check and see a negative value; which is dumb, but I'm being lazy
		$wheel -= $val;
	}
	elsif ($op eq 'R') { $wheel += $val; }

	$total++ if ($wheel <= 0 or $wheel >= 100);
	$wheel %= 100;

	print "Line $.: wheel = $wheel; total = $total\n" if ($debug > 0);
}

# Print solution
print "Solution: $total\n";
