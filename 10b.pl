#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };
use constant PI => atan2 0, -1;

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
            ? [$p <=> 0, 0]
            : [0, $q <=> 0];
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

sub visible {
    my ($x, $y, $partial) = @_;
    my @visible;
    for my $j (($partial ? $y : 0) .. $#map) {
        for my $i (0 .. $#{ $map[$j] }) {
            next if $j == $y
                 && ($partial ? $i <= $x : $i == $x)
                 || ! $map[$j][$i];

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
            if ($clear) {
                push @visible, [$i, $j];
                push @visible, [$x, $y] if $partial;
            }
        }
    }
    return \@visible
}

my @can_see;
sub can_see {
    ++$can_see[ $_->[0] ][ $_->[1] ] for @{ visible(@_, 1) };
}

my $best = 0;
my ($best_x, $best_y);
for my $y (0 .. $#map) {
    for my $x (0 .. $#{ $map[$y] }) {
        next unless $map[$y][$x];
        can_see($x, $y);
        if (($can_see[$x][$y] // 0) > $best) {
            $best = $can_see[$x][$y];
            ($best_x, $best_y) = ($x, $y);
        }
    }
}

my ($X, $Y) = ($best_x, $best_y);
my %by_angle;
for my $y (0 .. $#map) {
    for my $x (0 .. $#{ $map[$y] }) {
        next unless $map[$y][$x];

        my $angle = atan2 $x - $X, $Y - $y;
        $angle += 2 * PI if $angle < 0;
        push @{ $by_angle{$angle} }, [$x, $y];
    }
}

my @sorted;
for my $angle (sort { $a <=> $b } keys %by_angle) {
    my $i = $#sorted;
    push @sorted, sort {   (($X - $a->[0]) ** 2 + ($Y - $a->[1]) ** 2)
                       <=> (($X - $b->[0]) ** 2 + ($Y - $b->[1]) ** 2)
                  } @{ $by_angle{$angle} };
}

my $count = 1;
my $i = 0;
my %visible;
undef $visible{ $_->[0] }{ $_->[1] } for @{ visible($X, $Y) };
while ($count <= 200) {
    my ($x, $y) = @{ $sorted[$i] };
    if (exists $visible{$x} && exists $visible{$x}{$y}) {
        say "$count: $x $y";
        $map[$y][$x] = 0;
        ++$count;
    }
} continue {
    ++$i;
    if ($i > $#sorted) {
        $i = 0;
        %visible = ();
        undef $visible{ $_->[0] }{ $_->[1] } for @{ visible($X, $Y) };

    }
}

say $sorted[$i - 1][0] * 100 + $sorted[$i - 1][1];

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
