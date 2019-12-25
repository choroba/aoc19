#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant MAX => 4;

sub empty_layer { [ map [ map +(!1), 0 .. MAX ], 0 .. MAX ] }

my %grid;

while (<>) {
    chomp;
    push @{ $grid{0} }, [ map $_ eq '#', split // ];
}

$grid{-1} = empty_layer();
$grid{1}  = empty_layer();

my ($min, $max) = (-1, 1);
for my $step (1 .. 200) {
    my %next;
    for my $depth ($min .. $max) {
        for my $y (0 .. $#{ $grid{$depth} }) {
            for my $x (0 .. $#{ $grid{$depth}[$y] }) {
                next if 2 == $x && 2 == $y;

                my @moves;
                if (0 == $x) {
                    push @moves, [ $depth - 1, 2, 1 ];
                }  elsif (3 == $x && 2 == $y) {
                    push @moves, map [ $depth + 1, $_, MAX ], 0 .. MAX;
                } else {
                    push @moves, [ $depth, $y, $x - 1 ];
                }

                if (MAX == $x) {
                    push @moves, [ $depth - 1, 2, 3 ];
                } elsif (1 == $x && 2 == $y) {
                    push @moves, map [ $depth + 1, $_, 0], 0 .. MAX;
                } else {
                    push @moves, [ $depth, $y, $x + 1 ];
                }

                if (0 == $y) {
                    push @moves, [ $depth - 1, 1, 2 ];
                } elsif (2 == $x && 3 == $y) {
                    push @moves, map [ $depth + 1, MAX, $_], 0 .. MAX;
                } else {
                    push @moves, [ $depth, $y - 1, $x ];
                }

                if (MAX == $y) {
                    push @moves, [ $depth - 1, 3, 2 ];
                } elsif (2 == $x && 1 == $y) {
                    push @moves, map [ $depth + 1, 0, $_], 0 .. MAX;
                } else {
                    push @moves, [ $depth, $y + 1, $x ];
                }

                my $neighbours = 0;
                ++$neighbours
                    for grep $grid{ $_->[0] }[ $_->[1] ][ $_->[2] ],
                        @moves;

                $next{$depth}[$y][$x] = $grid{$depth}[$y][$x];
                $next{$depth}[$y][$x] = 1 if ! $grid{$depth}[$y][$x]
                                          && (  $neighbours == 1
                                             || $neighbours == 2);
                $next{$depth}[$y][$x] = !1 if $grid{$depth}[$y][$x]
                                   && $neighbours != 1;

                $next{--$min} = empty_layer()
                    if $depth == $min && $next{$depth}[$y][$x];
                $next{++$max} = empty_layer()
                    if $depth == $max && $next{$depth}[$y][$x];
            }
        }
    }
    %grid = %next;
}
my $sum = 0;
for my $layer (values %grid) {
    for my $row (@$layer) {
        ++$sum for grep $_, @$row;
    }
}

say $sum;

__DATA__
....#
#..#.
#..##
..#..
#....
