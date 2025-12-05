package My::AoC::Helper;
use strict;
use warnings;
 
use Exporter qw(import);
 
our @EXPORT_OK = qw(coordValid getDirOffsetCoord getNeighbors getOrthoNeighbors wrapCoord);

# coordValid(\@coord, \@array);
sub coordValid {
    my ($coordRef, $aRef) = @_;

    my @coord = @{$coordRef};
    my @array = @{$aRef};

    my $dimension = scalar @coord;

    if ( $dimension == 2 ) {
        my $row = $coord[0];
        my $col = $coord[1];

        if ( $row >= 0 && $row < @array) {
            if ( $col >= 0 && $col < @{$array[$row]} ) {
                return 1;
            }
        }
        return 0;
    }
}

# getDirOffsetCoord([$row, $col], $direction, $distance)
# getDirOffsetCoord(\@coord, $direction, $distance)
sub getDirOffsetCoord { 
	my $coordRef = shift;
	my @coord = @{$coordRef};
	my $dir = shift;
	my $distance = shift;
	
	my %dirs = (
		nw => [-1, -1],
		n => [-1, 0],
		ne => [-1, 1],
		e => [0, 1],
		se => [1, 1],
		s => [1, 0],
		sw => [1, -1],
		w => [0, -1]
	);
	my $row = $coord[0] + ($distance * $dirs{$dir}[0]);
	my $col = $coord[1] + ($distance * $dirs{$dir}[1]);
	return $row, $col;
}

sub getNeighbors {
    my ($row, $col) = @_;
    return [$row-1, $col-1], [$row-1, $col], [$row-1, $col+1], [$row, $col-1], [$row, $col+1], [$row+1, $col-1], [$row+1, $col], [$row+1, $col+1];
}

sub getOrthoNeighbors {
    my ($row, $col) = @_;
    return [$row-1, $col], [$row, $col-1], [$row, $col+1], [$row+1, $col];
}

sub wrapCoord {
    my ($coordRef, $aRef) = @_;

    my @coord = @{$coordRef};
    my @array = @{$aRef};

    my $dimension = scalar @coord;

    if ( $dimension == 2 ) {
        my $row = $coord[0];
        my $col = $coord[1];

        my $rowCount = scalar @array;
        my $colCount = scalar @{$array[$row]};

        # I think Perl's default % implementation would handle negatives correctly in this context
        # But, if I ever "use integer" in this file, it could unintentionally change that behavior
        while ( $row < 0 ) { $row += $rowCount; }
        while ( $col < 0 ) { $col += $colCount; }

        $row %= $rowCount;
        $col %= $colCount;

        return [$row, $col];
    }
}

1;
