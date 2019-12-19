#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode = 'Intcode'->new;
my @src = split /,/, <>;

sub at {
    $intcode->load(@src);
    $intcode->input(reverse @_);
    $intcode->run;
    my $o = $intcode->output->[-1];
    $intcode->flush;
    $o
}

sub f { int(($_[0]+1) / 50 * 33)}
sub t { int(($_[0]+1) / 25 * 19)}

# use Test::More;

# my $from = 0;
# for my $x (0 .. 225) {
#     print "$x:\t";
#     my $previous = 0;
#     for my $y ($from .. 250) {
#         my $at = at($x, $y);
#         unless ($at == $previous) {
#             print "$y\t";
#             if ($at) {
#                 is f($x), $y;
#                 $from = $y - 1;
#             } else {
#                 is t($x), $y;
#                 last
#             }
#         }
#         $previous = $at;
#     }
#     print "\n";
# }


# do {
#     ok at($_, f($_)), "f $_";
#     ok ! at($_, f($_) - 4), "f-1 $_";
#     ok at($_, t($_) - 2), "t-1 $_";
#     ok ! at($_, t($_)), "t $_";
# } for 10, 20, 30, 40, 50, 100, 150, 200, 400, 500, 760, 1660;

for my $x (1620 .. 1650) {
    for my $y(map t($x) - 100 + $_, -5 .. 5) {
        my $ok =  at($x, $y)
               && at($x, $y + 99)
               && at($x + 99, $y);

        my $nok = 0;
        for my $alt ([left  => $x - 1, $y],
                     [right => $x, $y - 1],
                     [diag  => $x - 1, $y - 1]
                     ) {
            my ($name, $m, $n) = @$alt;
            $nok +=    at($m, $n)
                    && at($m, $n + 99)
                    && at($m + 99, $n);
        }
        say "$y$x" if $ok && !$nok;
    }
}
