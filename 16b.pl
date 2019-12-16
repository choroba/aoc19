#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my @input = (grep $_ ne "\n", split //, <>) x 10_000;
splice @input, 0, join "", @input[0 .. 6];

for my $phase (1 .. 100) {
    $input[$_] = (($input[$_ + 1] // 0) + $input[$_]) % 10
        for reverse 0 .. $#input;
    say @input[0..7];
}
