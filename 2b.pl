#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @orig = split /,/, <>;
my $intcode = 'Intcode'->new;

TRY:
for my $noun (0 .. 99) {
    for my $verb (0 .. 99) {
        my @src = @orig;
        $src[1] = $noun;
        $src[2] = $verb;
        $intcode->load(@src);
        $intcode->run;
        if ($intcode->result == 19690720) {
            say 100 * $noun + $verb;
            last TRY
        }
    }
}
