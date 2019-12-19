#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode = 'Intcode'->new;
my @src = split /,/, <>;
my $sum = 0;
for my $x (0 .. 49) {
    for my $y (0 .. 49) {
        $intcode->load(@src);
        $intcode->input($x, $y);
        $intcode->run;
        $sum += $intcode->output->[-1];
        $intcode->flush;
    }
}
say $sum;
