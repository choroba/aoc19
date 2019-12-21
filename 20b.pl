#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my @map;

sub is_outer {
    my ($y, $x) = @_;
    return $x == 2 || $x + 2 == $#{ $map[2] }
        || $y == 2 || $y + 2 == $#map
}

while (<>) {
    chomp;
    push @map, [split //];
}

my %teleport;
for my $y (1 .. $#map) {
    for my $x (1 .. $#{ $map[$y] }) {
        if ($map[$y][$x] =~ /[[:upper:]]/) {
            if ($map[ $y - 1 ][$x] =~ /[[:upper:]]/) {
                my $t = "$map[ $y - 1 ][$x]$map[$y][$x]";
                push @{ $teleport{$t} },
                    ($y > 1 && '.' eq $map[ $y - 2 ][$x])
                    ? [ $y - 2, $x ]
                    : [ $y + 1, $x ];
            } elsif ($map[$y][ $x - 1 ] =~ /[[:upper:]]/) {
                my $t = "$map[$y][ $x - 1 ]$map[$y][$x]";
                push @{ $teleport{$t} },
                    ($x > 1 && '.' eq $map[$y][ $x - 2 ])
                    ? [ $y, $x - 2 ]
                    : [ $y, $x + 1 ];
            }
        }
    }
}

my %DISTANCE;
my @map_distance;
my @agenda;
for my $t (keys %teleport) {
    for my $coord (@{ $teleport{$t} }) {
        my $suffix = is_outer($coord->[0], $coord->[1]) ? 'o' : 'i';
        $map_distance[ $coord->[0] ][ $coord->[1] ]{$t . $suffix} = 0;
        $DISTANCE{ $t . $suffix }{ $t . $suffix } = 0;
        $DISTANCE{ $t . 'i' }{ $t . 'o' }
            = $DISTANCE{ $t . 'o' }{ $t . 'i' }
            = 1 unless $t eq 'AA' || $t eq 'ZZ';
        push @agenda, [ $coord->[0], $coord->[1], $t . $suffix ];
    }
}

while (@agenda) {
    my @next;
    for my $coord (@agenda) {
        my ($y, $x, $tl) = @$coord;
        my ($t, $layer) = $tl =~ /(\D+)(\d+)/;
        my $d = $map_distance[$y][$x]{$tl} // 0;
        for my $step ([0, 1], [0, -1], [1, 0], [-1, 0]) {
            my ($m, $n) = ($x + $step->[0], $y + $step->[1]);
            next unless '.' eq $map[$n][$m];

            if (($map_distance[$n][$m]{$tl} // 'Inf') > 1 + $d) {
                $map_distance[$n][$m]{$tl} = 1 + $d;
                push @next, [ $n, $m, $tl ];

                for my $tl2 (keys %{ $map_distance[$n][$m] }) {
                    next if $tl2 eq $tl;

                    my $d2 = $d + $map_distance[$n][$m]{$tl2} + 1;
                    $DISTANCE{$tl}{$tl2} = $d2
                        if $d2 < ($DISTANCE{$tl}{$tl2} // 'Inf');
                }
            }
        }
    }
    @agenda = @next;
}

my %distance = map +(s/i/1/r => $DISTANCE{AAo}{$_}),
               grep /i$/,
               keys %{ $DISTANCE{AAo} };

my %agenda = map +($_ => undef), grep /1$/, keys %distance;

until ($distance{ZZ0}) {
    my %next;
    for my $tl (keys %agenda) {
        my ($t, $l) = $tl =~ /(\D+)(\d+)/;
        my $d = $distance{$t};
        my $L = ('o', 'i')[$l % 2];

        for my $tL2 (keys %{ $DISTANCE{ $t . $L } }) {
            my ($t2, $L2) = $tL2 =~ /(\w+?)(.)$/;
            my $l2;
            if ($L eq $L2) {
                $l2 = $l;
            } elsif ($t eq $t2) {
                $l2 = $l + ($L eq 'o' ? - 1 : 1);
            } else {
                $l2 = $l + ($L eq 'o' ? 1 : -1);
            }
            my $tl2 = $t2 . $l2;
            next if $tl2 =~ /^(?:(?:AA|ZZ)[^0]|(?<!AA|ZZ)0)$/ || $l2 < 0;

            my $d = $distance{$tl} + $DISTANCE{ $t . $L }{$tL2};
            if ($d < ($distance{$tl2} // 'Inf')) {
                $distance{$tl2} = $d;
                undef $next{$tl2};
            }
        }

    }
    %agenda = %next;
}

say $distance{ZZ0};
