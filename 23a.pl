#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @program = split /,/, <>;

my @computers;

for my $i (0 .. 49) {

    say $i;

    push @computers, 'Intcode'->new;
    $computers[-1]->load(@program);
    $computers[-1]->pause(2);

    $computers[-1]->default_in(-1);
    $computers[-1]->input($i);
    $computers[-1]->run;
}

while (1) {
    for my $i (0 .. 49) {
        say "* $i";
        $computers[$i]->run;

        if (@{ $computers[$i]->output // []}) {
            $computers[$i]->run until 0 == @{ $computers[$i]->output } % 3;
            my @packets = @{ $computers[$i]->output };
            $computers[$i]->shorten(scalar @packets);
            while (my ($target, $x, $y) = splice @packets, 0, 3) {
                if ($target > 49) {
                    say "$target $x $y.";
                    exit
                }
                $computers[$target]->input($x, $y);
                say "$i --> $target \[$x, $y]";
            }
        }
    }
}
