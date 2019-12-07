#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @in = split /,/, <>;

my $max = 0;
my $intcode = 'Intcode'->new;
for my $settings ('01234' .. '43210') {
    next if $settings =~ /[5-9]/ || $settings =~ /(.).*\1/;

    my $result = 0;
    for my $setting (split //, $settings) {
        $intcode->load(@in);
        $intcode->input($setting, $result);
        $intcode->run;
        $result = $intcode->output->[-1];
    }
    $max = $result if $max < $result;
}
say $max;
