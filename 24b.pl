#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %grid;

while (<>) {
    chomp;
    push @{ $grid{0} }, [ map $_ eq '#', split // ];
}

while (1) {
    for my $depth (sort keys %grid) {
        say $depth;
        say map { map($_ ? '#' : '.', @$_), "\n" } @{ $grid{$depth} };
        sleep 1;

        my %next;
        for my $y (0 .. $#{ $grid{$depth} }) {
            for my $x (0 .. $#{ $grid{$depth}[$y] }) {
                my $neighbours = 0;
                ++$neighbours for grep {
                    my ($i, $j) = ($x + $_->[0], $y + $_->[1]);
                    $i >= 0 && $j >= 0
                        && $i <= $#{ $grid{$depth}[$y] }
                        && $j <= $#{ $grid{$depth} }
                        && $grid{$depth}[$j][$i]
                }[-1, 0], [1, 0], [0, 1], [0, -1];
                $next{$depth}[$y][$x] = $grid{$depth}[$y][$x];
                $next{$depth}[$y][$x] = 1 if ! $grid{$depth}[$y][$x]
                                          && (  $neighbours == 1
                                             || $neighbours == 2);
                $next{$depth}[$y][$x] = !1 if $grid{$depth}[$y][$x]
                                   && $neighbours != 1;
            }
        }
        %grid = %next;
    }
}

__DATA__
....#
#..#.
#..##
..#..
#....

