#!/usr/bin/perl
use warnings;
use strict;

my $debug = 0;
my $total = 0;

my @input;

while (<>) {
	chomp;
	push @input, [split /,/];
}

foreach my $c (0 .. $#input-1) {
	my ($cx, $cy) = @{$input[$c]};
	RECT: foreach my $d ($c+1 .. $#input) {
		my ($dx, $dy) = @{$input[$d]};
		my $w = abs($cx - $dx) + 1;
		my $h = abs($cy - $dy) + 1;
		my $area = $w * $h;
		my ($sx1, $sx2) = sort { $a <=> $b } ($cx, $dx);
		my ($sy1, $sy2) = sort { $a <=> $b } ($cy, $dy);
		if ($area > $total) {
			# check if any coordinates are contained within the rectangle
			foreach my $p (0 .. $#input) {
				my ($px, $py) = @{$input[$p]};
				next RECT if ($sx1 < $px and $px < $sx2 and $sy1 < $py and $py < $sy2);
			}
			# foreach perimeter line, check for any intersecting lines
			foreach my $lineRef (getBox($c, $d)) {
				my @line = @{$lineRef};

				my @p1 = @{$line[0]};
				my @p2 = @{$line[1]};

				my $p1x = $p1[0];
				my $p1y = $p1[1];
				my $p2x = $p2[0];
				my $p2y = $p2[1];

				#if perimeter line is horizontal
				if ($p1y == $p2y) {
					#check input for lines with (minPLineX < inX < maxPLineX and minInY < pLineY < maxInY)
					foreach my $i (0 .. $#input) {
						my ($hx, $hy) = @{$input[$i-1]};
						my ($ix, $iy) = @{$input[$i]};
						my ($minInY, $maxInY) = sort { $a <=> $b } ($hy, $iy);
						my ($minPerLineX, $maxPerLineX) = sort { $a <=> $b } ($p1x, $p2x);
						next RECT if ($minPerLineX < $ix and $ix < $maxPerLineX and $minInY < $p1y and $p1y < $maxInY);
					}
				}
				#if perimeter line is vertical
				if ($p1x == $p2x) {
					#check input for lines with (minPLineY < inY < maxPLineY and minInX < pLineX < maxInX)
					foreach my $i (0 .. $#input) {
						my ($hx, $hy) = @{$input[$i-1]};
						my ($ix, $iy) = @{$input[$i]};
						my ($minInX, $maxInX) = sort { $a <=> $b } ($hx, $ix);
						my ($minPerLineY, $maxPerLineY) = sort { $a <=> $b } ($p1y, $p2y);
						next RECT if ($minPerLineY < $iy and $iy < $maxPerLineY and $minInX < $p1x and $p1x < $maxInX);
					}
				}
			}
			# check for input lines that start/stop on a perimeter line?
			#   No, because one of the following:
			#     1. The other end lands inside the box and so the box is rejected
			#     2. The line goes through the entire box, and forms a line that intersect the opposite side of the box, so the box is rejected
			#     3. The line goes outward from the box, and the box is not (yet) invalidated
			$total = $area;
		}
	}
}

# Print solution
print "Solution: $total\n";

sub getBox {
	my $c = shift;
	my $d = shift;
	my ($cx, $cy) = @{$input[$c]};
	my ($dx, $dy) = @{$input[$d]};
	my @ogpoints = ([$cx,$cy],[$dx,$dy]);
	my @adpoints = ([$cx,$dy],[$dx,$cy]);
	my @lines;
	foreach my $ptA (@ogpoints) {
		foreach my $ptB (@adpoints) {
			push @lines, [$ptA, $ptB];
		}
	}
	return @lines;
}
