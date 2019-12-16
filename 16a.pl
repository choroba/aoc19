#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @PATTERN = (0, 1, 0, -1);

my @input = grep $_ ne "\n", split //, <>;

for my $phase (1 .. 100) {
    my @pattern = @PATTERN;
    my @output;
    for my $output_pos (0 .. $#input) {
        my $s = 0;
        for my $input_pos (0 .. $#input) {
            my $num = $input[$input_pos]
                    * $pattern[ ($input_pos + 1) % @pattern ];
            $s += $num;
        }
        push @output, $s =~ /(.)$/;
        @pattern = map +($_) x ($output_pos + 2), @PATTERN;
    }
    say @output;
    @input = @output;
}


__DATA__
80871224585914546619083218645595
