#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @items = ('mutex', 'dark matter', 'klein bottle', 'tambourine',
             'fuel cell', 'astrolabe', 'monolith', 'cake');

open my $in, '<', '25.in' or die $!;

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <$in>);
$intcode->pause(3);

open my $walk, '<', '25.walk' or die $!;

$intcode->input_str(do { local $/; <$walk> } . "inv\n");

$intcode->run;
my @out = map chr, @{ $intcode->output };
say @out;
$intcode->shorten(scalar @out);
for my $charf (0 .. 255) {
    say $charf;
    $intcode->input_str("drop $_\n") for @items;
    my @binary = split //, unpack 'B*', pack 'C', $charf;
    for my $i (0 .. 7) {
        say($items[$i]), $intcode->input_str("take $items[$i]\n") if $binary[$i];
    }
    $intcode->input_str("inv\n");
    $intcode->input_str("north\n");
    $intcode->run;
    my @out = map chr, @{ $intcode->output };
    say @out;
    last unless join("", @out) =~ /Alert/;
    $intcode->shorten(scalar @out);
}
