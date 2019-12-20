#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Data::Dumper;

my @map;
while (<>) {
    chomp;
    push @map, [split //];
}

my (%teleport, %is_teleport);
for my $y (1 .. $#map) {
    for my $x (1 .. $#{ $map[$y] }) {
        if ($map[$y][$x] =~ /[[:upper:]]/) {
            if ($map[ $y - 1 ][$x] =~ /[[:upper:]]/) {
                my $t = "$map[ $y - 1 ][$x]$map[$y][$x]";
                push @{ $teleport{$t} },
                    ($y > 1 && '.' eq $map[ $y - 2 ][$x])
                    ? do { $is_teleport{ $y - 2 }{$x} = $t; [ $y - 2, $x ] }
                    : do { $is_teleport{ $y + 1 }{$x} = $t; [ $y + 1, $x ] };
            } elsif ($map[$y][ $x - 1 ] =~ /[[:upper:]]/) {
                my $t = "$map[$y][ $x - 1 ]$map[$y][$x]";
                push @{ $teleport{$t} },
                    ($x > 1 && '.' eq $map[$y][ $x - 2 ])
                    ? do { $is_teleport{$y}{ $x - 2 } = $t; [ $y, $x - 2 ] }
                    : do { $is_teleport{$y}{ $x + 1 } = $t; [ $y, $x + 1 ]; }
            }
        }
    }
}
my %distance;
my @map_distance;
my @agenda;
for my $t (keys %teleport) {
    for my $coord (@{ $teleport{$t} }) {
        $map_distance[ $coord->[0] ][ $coord->[1] ]{$t} = 0;
        push @agenda, [ $coord->[0], $coord->[1], $t ];
    }
}

while (@agenda) {
    my @next;
    for my $coord (@agenda) {
        my ($y, $x, $t) = @$coord;
        my $d = $map_distance[$y][$x]{$t};
        for my $step ([0, 1], [0, -1], [1, 0], [-1, 0]) {
            my ($m, $n) = ($x + $step->[0], $y + $step->[1]);
            next unless '.' eq $map[$n][$m];
            if (($map_distance[$n][$m]{$t} // 'Inf') > 1 + $d) {
                $map_distance[$n][$m]{$t} = 1 + $d;
                if (my $t2 = $is_teleport{$n}{$m}) {
                    if (($distance{$t}{$t2} // 'Inf') > 1 + $d) {
                        $distance{$t}{$t2} = 1 + $d;
                        $distance{$t2}{$t} = 1 + $d;
                    }
                }
                push @next, [$n, $m, $t];
            }
        }
    }
    @agenda = @next;
}

my %agenda = %{ $distance{AA} };
while (keys %agenda) {
    my %next;
    for my $t1 (keys %agenda) {
        for my $t2 (keys %{ $distance{$t1} }) {
            my $d = $distance{$t1}{$t2} + $distance{AA}{$t1} + 1;
            if ($d < ($distance{AA}{$t2} // 'Inf')) {
                $distance{AA}{$t2} = $d;
                undef $next{$t2};
            }
        }
    }
    %agenda = %next;
}

say $distance{AA}{ZZ};
