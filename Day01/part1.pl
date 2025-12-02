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

my $wheel = 50;	# wheel value starts at 50

while (<>) {
	chomp;
	my ($op, $val) = m/([LR])(\d+)/;

	print "Line $., $op, $val\n" if ($debug > 0);

	if ($op eq 'L') { $wheel -= $val; }
	elsif ($op eq 'R') { $wheel += $val; }
	else { die "Invalid input at line $.\n"; }

	$wheel %= 100;
	$total++ if ($wheel == 0);
}

# Print solution
print "Solution: $total\n";
