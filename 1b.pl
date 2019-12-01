#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

sub fuel { int($_[0] / 3) - 2 }

sub fuel2 {
    my ($fuel) = @_;
    my $sum = 0;
    while (1) {
        $fuel = fuel($fuel);
        last if $fuel <= 0;
        $sum += $fuel;
    }
    return $sum
}

my $sum = 0;
while (<>) {
    $sum += fuel2($_);
}
say $sum;

__END__

use Test::More tests => 3;
is fuel2(14), 2;
is fuel2(1969), 966;
is fuel2(100756), 50346;
