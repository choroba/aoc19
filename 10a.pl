#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @map;
while (<>) {
    chomp;
    push @map, [ map '#' eq $_, split // ];
}

my %lowest_terms;
sub lowest_terms {
    my ($p, $q) = @_;
    return @{ $lowest_terms{$p}{$q} }
        if exists $lowest_terms{$p} && exists $lowest_terms{$p}{$q};

    if ($p * $q == 0) {
        $lowest_terms{$p}{$q} = $p
            ? [1, 0]
            : [0, 1];
    } else {
        my ($i, $j) = (abs $p, abs $q);
        while ($i > 1 && $j > 0) {
            ($i, $j) = ($j, $i) if $i > $j;
            $j %= $i;
        }
        $lowest_terms{$p}{$q} = [ $p / $i, $q / $i ];
    }
    $lowest_terms{$q}{$p} = [ reverse @{ $lowest_terms{$p}{$q} } ];
    return @{ $lowest_terms{$p}{$q} }
}

my @can_see;
sub can_see {
    my ($x, $y) = @_;
    for my $j ($y .. $#map) {
        for my $i (0 .. $#{ $map[$j] }) {
            next if $j == $y && $i <= $x || ! $map[$j][$i];

            my @vector = lowest_terms($i - $x, $j - $y);
            my ($m, $n, $clear) = ($x + $vector[0], $y + $vector[1], 1);
            while ($m != $i || $n != $j) {
                if ($map[$n][$m]) {
                    $clear = 0;
                    last
                }
                $m += $vector[0];
                $n += $vector[1];
            }
            $can_see[$x][$y] += $clear;
            $can_see[$i][$j] += $clear;
        }
    }
}

my $best = 0;
for my $y (0 .. $#map) {
    for my $x (0 .. $#{ $map[$y] }) {
        next unless $map[$y][$x];
        can_see($x, $y);
        $best = $can_see[$x][$y] if ($can_see[$x][$y] // 0) > $best;
    }
}
say $best;

__DATA__
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
