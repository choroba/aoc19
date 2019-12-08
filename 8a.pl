#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my $SIZE = 25 * 6;

open my $in, '<', shift or die $!;

my $min = $SIZE;
my $result;
while ($SIZE == read $in, my $layer, $SIZE) {
    my $zeros = $layer =~ tr/0//;
    if ($zeros < $min) {
        my $ones = $layer =~ tr/1//;
        my $twos = $layer =~ tr/2//;
        $result = $ones * $twos;
        $min = $zeros;
    }
}
say $result;
