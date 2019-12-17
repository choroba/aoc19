#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode = 'Intcode'->new;
$intcode->load(my @input = split /,/, <>);
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

$input[0] = 2;
$intcode = 'Intcode'->new;
$intcode->load(@input);

$intcode->input(map ord, split //, << '12345678901234567890');
A,B,A,C,A,B,C,A,B,C
R,8,R,10,R,10
R,4,R,8,R,10,R,12
R,12,R,4,L,12,L,12
n
12345678901234567890

$intcode->run;
use Data::Dumper; print Dumper $intcode->output;
