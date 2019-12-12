#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::Util qw{ sum };

my @moons;
while (<>) {
    push @moons, [/-?[0-9]+/g, 0, 0, 0];
}

for my $i (1 .. 1_000) {
    for my $m1 (0 .. $#moons) {
        for my $m2 ($m1 + 1 .. $#moons) {
            for my $dim (0 .. 2) {
                my $cmp = $moons[$m1][$dim] <=> $moons[$m2][$dim];
                $moons[$m1][$dim + 3] -= $cmp;
                $moons[$m2][$dim + 3] += $cmp;
            }
        }
    }
    for my $m (@moons) {
        for my $dim (0 .. 2) {
            $m->[$dim] += $m->[$dim + 3];
        }
    }
    my $energy = sum(
        map { sum(map abs, @$_[0 .. 2])
            * sum(map abs, @$_[3 .. 5])
        } @moons
    );
    say "$i\t$energy";
}
