#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @TILE = (' ', '#', 'x', '_', 'o');

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
$intcode->pause(1);

my @grid;
until ($intcode->finished) {
    $intcode->run;
    my $x = $intcode->output->[-1];
    $intcode->run;
    my $y = $intcode->output->[-1];
    $intcode->run;
    my $type = $intcode->output->[-1];
    $grid[$y][$x] = $TILE[$type];
}
my $count = grep 'x' eq $_, map @$_, @grid;
say $count;
