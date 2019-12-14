#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use POSIX qw{ ceil };

my %reactions;
while (<>) {
    chomp;
    my ($from, $to) = split / => /;
    my @sources;
    while ($from =~ /(\d+) ([^,]+)/g) {
        push @sources, [ $1, $2 ];
    }
    my ($count, $chemical) = split / /, $to;
    push @{ $reactions{$chemical}{$count} }, @sources;
}

my %needed = ( FUEL => [1] );
while (1) {
    last if exists $needed{ORE}
         && ! grep $needed{$_}[0] > 0, grep 'ORE' ne $_, keys %needed;

    for my $ch (keys %needed) {

        next if 'ORE' eq $ch || 0 == $needed{$ch}[0];

        my $target_quantity = (keys %{ $reactions{$ch} })[0];

        for my $source_tuple (@{ $reactions{$ch}{$target_quantity} }) {

            my ($src_qnt, $src) = @$source_tuple;
            my $times = ceil($needed{$ch}[0] / $target_quantity);

            $needed{$src}[0] += $times * $src_qnt;
            if ($needed{$src}[1]) {
                my $diff = $needed{$src}[0] - $needed{$src}[1];
                if ($diff > 0) {
                    $needed{$src} = [ $diff, 0 ];
                } else {
                    $needed{$src} = [ 0, -$diff ];
                }
            }

            $needed{$ch}[1] = $times * $target_quantity - $needed{$ch}[0];
        }
        $needed{$ch}[0] = 0;
        delete $needed{$ch} unless $needed{$ch}[1];
    }
}

say $needed{ORE}[0];
