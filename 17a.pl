#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
$intcode->run;

my @map = [];
for (map chr, @{ $intcode->output }) {
    if ("\n" eq $_) {
        push @map, [];
    } else {
        push @{ $map[-1] }, $_;
    }
}
pop @map for 1, 2;

my $calibration = 0;
for my $y (0 .. $#map) {
    for my $x (0 .. $#{ $map[$y] }) {
        my $neighbours = 0;
        if ($map[$y][$x] eq '#') {
            for ([-1, 0], [0, 1], [1, 0], [0, -1]) {
                my ($m, $n) = ($x + $_->[0], $y + $_->[1]);
                ++$neighbours if $m >= 0
                              && $n >= 0
                              && $m <= $#{ $map[$y] }
                              && $n <= $#map
                              && $map[$n][$m] eq '#';
            }
            $calibration += $x * $y if $neighbours > 2;
        }
    }
}
say @$_ for @map;
say $calibration;
