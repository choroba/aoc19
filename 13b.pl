#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @TILE = (' ', '#', 'x', '_', 'o');

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
$intcode->set(0, 2);
$intcode->pause(1);
$intcode->input(0);

my @grid;
my ($ball, $paddle);
my $score = 0;
until ($intcode->finished) {
    $intcode->run;
    my $x = $intcode->output->[-1];

    $intcode->run;
    my $y = $intcode->output->[-1];

    $intcode->run;
    my $type = $intcode->output->[-1];
    if (-1 == $x && 0 == $y) {
        $score = $type;

    } elsif (defined $TILE[$type]) {
        $grid[$y][$x] = $TILE[$type];
        $ball   = $x if 'o' eq $TILE[$type];
        $paddle = $x if '_' eq $TILE[$type];

        if ('o' eq $TILE[$type] && defined $paddle) {
            $intcode->input($ball <=> $paddle)
                if defined $ball;
        }
    }
}
say $score;
