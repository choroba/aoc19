#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @program = split /,/, <>;

my @computers;

for my $i (0 .. 49) {
    push @computers, 'Intcode'->new;
    $computers[-1]->load(@program);
    $computers[-1]->pause(2);

    $computers[-1]->default_in(-1);
    $computers[-1]->input($i);
    $computers[-1]->run;
}

my @nat;
my $sent;

while (1) {
    my $active = 0;
    for my $i (0 .. 49) {
        $computers[$i]->run;

        $active++ unless $computers[$i]->idle;

        if (@{ $computers[$i]->output // []}) {
            $computers[$i]->run until 0 == @{ $computers[$i]->output } % 3;
            my @packets = @{ $computers[$i]->output };
            $computers[$i]->shorten(scalar @packets);
            while (my ($target, $x, $y) = splice @packets, 0, 3) {
                if ($target == 255) {
                    @nat = ($x, $y);
                } else {
                    $computers[$target]->input($x, $y);
                }
            }
        }
    }
    if (! $active && @nat) {
        $computers[0]->input(@nat);
        say($sent), exit
            if $nat[1] == ($sent // 'NaN');

        $sent = $nat[1];
    }
}
