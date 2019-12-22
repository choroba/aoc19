#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::Util qw{ first };
use ARGV::OrDATA;

use constant MAX => 10006;
my $card = 2019;

while (<>) {
    chomp;
    if (/^deal i/) {
        $card = MAX - $card;

    } elsif (/^cut ([-\d]+)/) {
        $card -= $1;

    } elsif (my ($inc) = /(\d+)/) {  # increment
        $card *= $inc;
        $card %= (MAX + 1);
    }
}

say $card;


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
