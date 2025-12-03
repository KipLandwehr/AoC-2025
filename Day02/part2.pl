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

my %lenToDivs;

while (<>) {
	chomp;
	my ($min, $max) = split '-';

	VAL: for (my $val=$min; $val <= $max; $val++) {
		my $len = length($val);
		next if ($len == 1);

		unless (exists $lenToDivs{$len}) {		# if the length hasn't been seen before
			foreach my $width (2..int($len/2)) {
				if ($len % $width == 0) {
					my $reps = $len/$width;
					my $pattern = ("0" x ($width-1)) . "1";
					my $div = int($pattern x $reps);
					push @{$lenToDivs{$len}}, $div;
				}                    	
			}                            	
			my $div = int("1" x $len);
			push @{$lenToDivs{$len}}, $div;
		}                                    	

		foreach my $div (@{$lenToDivs{$len}}) {
			if ( $val % $div == 0 ) {
				$total += $val;
				next VAL;
			}
		}
	}
}

# Print solution
print "Solution: $total\n";
