#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use enum qw( UP RIGHT DOWN LEFT );

use lib '.';
use Intcode;

my %panel;
my ($x, $y) = (0, 0);
my $direction = UP;

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
$intcode->pause(1);

until ($intcode->finished) {
    $intcode->input($panel{"$x:$y"} // 0);
    $intcode->run;
    my $paint = $intcode->output->[-1];

    $intcode->run;
    my $turn = $intcode->output->[-1];

    $panel{"$x:$y"} = $paint;
    $direction += (-1, 1)[$turn];
    $direction %= 4;
    my $step = { (UP)    => [ 0, -1],
                 (RIGHT) => [ 1,  0],
                 (DOWN)  => [ 0,  1],
                 (LEFT)  => [-1,  0],
               }->{$direction};
    $x += $step->[0];
    $y += $step->[1];
}
say scalar keys %panel;
