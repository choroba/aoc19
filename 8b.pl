#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my $WIDTH = 25;
my $SIZE = $WIDTH * 6;

open my $in, '<', shift or die $!;

my $result = '2' x $SIZE;
while ($SIZE == read $in, my $layer, $SIZE) {
    for my $i (0 .. $SIZE - 1) {
        my $front = substr $result, $i, 1;
        next if $front != 2;

        my $back  = substr $layer,  $i, 1;
        substr $result, $i, 1, $back;
    }
}
say $result =~ s/.{$WIDTH}\K/\n/gr =~ tr/01/ #/r;
