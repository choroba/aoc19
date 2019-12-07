#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @in = split /,/, <>;

my $max = 0;
for my $settings ('56789' .. '98765') {
    next if $settings =~ /[0-4]/ || $settings =~ /(.).*\1/;

    my @amps = map 'Intcode'->new, 'A' .. 'E';
    for my $amp (@amps) {
        $amp->load(@in);
        $amp->pause(1);
        $amp->flush;
        $amp->input(substr $settings, 0, 1, "");
    }

    my $input = 0;
    until ($amps[-1]->finished) {
        for my $amp (0 .. $#amps) {
            warn "==$amp==\n" if $amps[$amp]->debug;
            $amps[$amp]->input($input);
            $amps[$amp]->run;
            $input = $amps[$amp]->output->[-1];
            warn "> $input\n" if $amps[$amp]->debug;
        }
    }
    $max = $input if $input > $max;
}
say $max;
