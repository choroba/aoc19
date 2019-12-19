#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $KEYS;

my @map;
my %distance;
my $shortest = 'Inf';

sub closest {
    my @process = @_;
    my @next;
    for my $triple (@process) {
        my ($x, $y, $keys) = @$triple;
        for my $move ([0, 1], [0, -1], [1, 0], [-1, 0]) {
            my ($m, $n) = ($x + $move->[0], $y + $move->[1]);

            my $object = $map[$n][$m];
            next if '#' eq $object;

            if (  exists $distance{$keys}{$m}{$n}
               && exists $distance{$keys}{$x}{$y}
            ) {
                next if $distance{$keys}{$m}{$n} <= $distance{$keys}{$x}{$y} + 1;
            }

            $distance{$keys}{$m}{$n} = $distance{$keys}{$x}{$y} + 1;

            if ('.' eq $object || -1 != index $keys, lc $object) {
                push @next, [$m, $n, $keys];

            } elsif ($object =~ /[[:lower:]]/) {
                my $keys2 = join "", sort $object, split //, $keys;
                if ($keys2 eq $KEYS) {
                    if ($distance{$keys}{$m}{$n} < $shortest) {
                        $shortest = $distance{$keys}{$m}{$n};
                        return $shortest
                    }
                }
                $distance{$keys2}{$m}{$n} = $distance{$keys}{$m}{$n};
                push @next, [$m, $n, $keys2];

            }
        }
    }
    @_ = @next; goto &closest
}

my ($x, $y);
my %keys;
while (<>) {
    chomp;
    my @chars = split //;
    push @map, \@chars;
    if (/@/g) {
        my $pos = pos() - 1;
        $chars[$pos] = '.';
        ($x, $y) = ($pos, $. - 1);
    }
    pos = 0;
    while (/([[:lower:]])/g) {
        undef $keys{$1};
    }
}
$KEYS = join "", sort keys %keys;

say 'Exp: ', @{ pop @map };

$distance{""}{$x}{$y} = 0;

say closest([$x, $y, ""]);

__DATA__
###############
#aB....@.....b#
#############A#
#d............#
###############
44
