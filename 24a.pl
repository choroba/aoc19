#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;

while (<>) {
    chomp;
    push @grid, [ map $_ eq '#', split // ];
}

my %seen;
while (1) {
    my $s = join"", map { map($_ ? '#' : '.', @$_), "\n" } @grid;
    say $s;
    last if $seen{$s}++;

    my @next;
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[$y] }) {
            my $neighbours = 0;
            ++$neighbours for grep {
                my ($i, $j) = ($x + $_->[0], $y + $_->[1]);
                $i >= 0 && $j >= 0
                    && $i <= $#{ $grid[$y] } && $j <= $#grid
                    && $grid[$j][$i]
            }[-1, 0], [1, 0], [0, 1], [0, -1];
            $next[$y][$x] = $grid[$y][$x];
            $next[$y][$x] = 1 if ! $grid[$y][$x]
                              && ($neighbours == 1 || $neighbours == 2);
            $next[$y][$x] = !1 if $grid[$y][$x]
                               && $neighbours != 1;
        }
    }
    @grid = @next;
}

my $diversity = 0;
for my $j (0 .. $#grid) {
    for my $i (0 .. $#{ $grid[$j] }) {
        next unless $grid[$j][$i];

        $diversity += 2 ** ($j * @grid + $i);
    }
}
say $diversity;

__DATA__
....#
#..#.
#..##
..#..
#....

