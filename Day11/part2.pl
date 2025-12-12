#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my %input;
my %cache_fft;
my %cache_dac;
my %cache_out;

# aaa: you hhh
while (<>) {
	chomp;
	my ($src, $dstStr) = split /: /;
	my @dst = split / /, $dstStr;
	$input{$src} = \@dst
}

my $svr2fft = countPaths("svr", "fft");
my $fft2dac = countPaths("fft", "dac");
my $dac2out = countPaths("dac", "out");

$total = $svr2fft * $fft2dac * $dac2out;

# Print solution
print "Solution: $total\n";


sub countPaths {
	my $start = shift;
	my $end = shift;

	return 1 if ($start eq $end);	# match this first when looking for out
	return 0 if ($start eq "out");	# when not looking for out, bail out when we find it

	if ($end eq "fft") {
		return $cache_fft{$start} if (exists $cache_fft{$start});
	}
	if ($end eq "dac") {
		return $cache_dac{$start} if (exists $cache_dac{$start});
	}
	if ($end eq "out") {
		return $cache_out{$start} if (exists $cache_out{$start});
	}

	my @paths = @{$input{$start}};
	my $val = 0;
	foreach my $path (@paths) {
		$val += countPaths($path, $end);
	}

	if ($end eq "fft") {
		$cache_fft{$start} = $val;
	}
	if ($end eq "dac") {
		$cache_dac{$start} = $val;
	}
	if ($end eq "out") {
		$cache_out{$start} = $val;
	}

	return $val;
}
