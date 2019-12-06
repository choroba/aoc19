#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %g = (COM => {r => 0});

my $sum = 0;
sub rank {
    my ($node) = @_;
    $g{$node}{r} //= $g{ $g{$node}{p} }{r} + 1;
    $sum += $g{$node}{r};
    no warnings 'recursion';
    rank($_) for keys %{ $g{$node}{ch} };
}

while (<>) {
    chomp;
    my ($p, $ch) = split /\)/;
    undef $g{$p}{ch}{$ch};
    $g{$ch}{p} = $p;
}

rank('COM');
my %common;
my $node = 'YOU';
undef $common{$node} while $node = $g{$node}{p};
$node = 'SAN';
while ($node = $g{$node}{p}) {
    last if exists $common{$node};
}

say $g{YOU}{r} + $g{SAN}{r} - 2 * $g{$node}{r} - 2;

__DATA__
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
