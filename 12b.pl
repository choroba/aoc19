#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Math::BigInt;
use List::Util qw{ sum product };

my @moons;
while (<>) {
    push @moons, [/-?[0-9]+/g, 0, 0, 0];
}

my @start = map [ @$_[0 .. 2] ], @moons;

my @period;
for my $i (0 .. 500_000) {
    my @same = (0, 0, 0);;
    for my $m (0 .. $#moons) {
        for my $dim (0 .. 2) {
            if ($moons[$m][$dim] == $start[$m][$dim]
                && 0 == $moons[$m][$dim + 3]
            ) {
                ++$same[$dim];
            }
        }
    }
    for my $dim (grep @moons == $same[$_], 0 .. 2) {
        $period[$dim] ||= $i;
    }


    for my $m1 (0 .. $#moons) {
        for my $m2 ($m1 + 1 .. $#moons) {
            for my $dim (0 .. 2) {
                my $cmp = $moons[$m1][$dim] <=> $moons[$m2][$dim];
                $moons[$m1][$dim + 3] -= $cmp;
                $moons[$m2][$dim + 3] += $cmp;
            }
        }
    }
    for my $m (0 .. $#moons) {
        for my $dim (0 .. 2) {
            $moons[$m][$dim] += $moons[$m][$dim + 3];
        }
    }
}

sub gcd {
	my ($x, $y) = @_;
	($x, $y) = ($y % $x, $x) while $x;
	$y
}

sub lcm {
	my ($x, $y) = @_;
	($x && $y) and $x / gcd($x, $y) * $y or 0
}

say "@period";

my $lcm = 1;
for my $p (map 'Math::BigInt'->new($_), @period) {
    $lcm = lcm($lcm, $p);
}
say $lcm
