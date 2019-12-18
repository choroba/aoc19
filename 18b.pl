#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::Util qw{ sum };

my $KEYS;

my @map;
my %distance;
my $shortest = 'Inf';

sub closest {
    my @process = @_;
    my @next;
    for my $state (@process) {
        my $keys = pop @$state;
        my @coord = @$state;
        for my $r (0 .. $#coord) {
            my ($x, $y) = @{ $coord[$r] };
            #warn "$r $x:$y $keys";
            for my $move ([0, 1], [0, -1], [1, 0], [-1, 0]) {
                my ($m, $n) = ($x + $move->[0], $y + $move->[1]);

                my $object = $map[$n][$m];
                next if '#' eq $object;

                if (  exists $distance{$keys}{$m}{$n}
                   && exists $distance{$keys}{$x}{$y}
                ) {
                    next if $distance{$keys}{$m}{$n} <= $distance{$keys}{$x}{$y} + 1;
                }

                die "MISS $keys $x $y" unless exists $distance{$keys}{$x}{$y};
                $distance{$keys}{$m}{$n} = $distance{$keys}{$x}{$y} + 1;

                if ('.' eq $object || -1 != index $keys, lc $object) {
                    my @coord2 = map { $_ == $r ? [$m, $n] : $coord[$_] }
                                 0 .. $#coord;
                    push @next, [@coord2, $keys];

                } elsif ($object =~ /[[:lower:]]/) {
                    my $keys2 = join "", sort $object, split //, $keys;
                    $distance{$keys2}{$m}{$n} = $distance{$keys}{$m}{$n};
                    my @coord2 = map { $_ == $r ? [$m, $n] : $coord[$_] }
                                 0 .. $#coord;
                    push @next, [@coord2, $keys2];
                    $distance{$keys2}{ $_->[0] }{ $_->[1] }
                        = $distance{$keys}{ $_->[0] }{ $_->[1] } for @coord2;
                    if ($keys2 eq $KEYS) {
                        my $sum_distance = sum(
                            map $distance{$KEYS}{ $_->[0] }{ $_->[1] }, @coord2);
                        if ($sum_distance < $shortest) {
                            $shortest = $sum_distance;
                        }
                    }
                }
            }
        }
    }
    @_ = @next; goto &closest if @next;
    return $shortest
}

my (@r);
my %keys;
while (<>) {
    chomp;
    my @chars = split //;
    push @map, \@chars;
    while (/@/g) {
        my $pos = pos() - 1;
        $chars[$pos] = '.';
        push @r, [$pos, $. - 1];
    }
    pos = 0;
    while (/([[:lower:]])/g) {
        undef $keys{$1};
    }
}
$KEYS = join "", sort keys %keys;

say 'Exp: ', @{ pop @map };

$distance{""}{$_->[0]}{$_->[1]} = 0 for @r;

say closest([@r, ""]);
