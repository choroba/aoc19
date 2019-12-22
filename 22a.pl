#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::Util qw{ first };
use ARGV::OrDATA;

use constant MAX => 10006;

my @cards = (0 .. MAX);
while (<>) {
    chomp;
    if (/^deal i/) {
        @cards = reverse @cards;

    } elsif (/^cut ([-\d]+)/) {
        unshift @cards, splice @cards, $1;

    } elsif (my ($inc) = /(\d+)/) {  # increment
        my @new;
        for my $i (0 .. MAX) {
            $new[ ($i * $inc) % (MAX + 1) ] = $cards[$i];
        }
        @cards = @new;
    }
}

say first { $cards[$_] == 2019 } 0 .. $#cards;


__DATA__
deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1
