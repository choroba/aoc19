#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode;
$intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);

my $script = << '__SCRIPT__';
OR A J
AND B J
AND C J
NOT J J
AND D J
OR H T
OR E T
AND T J
RUN
__SCRIPT__

$intcode->input(map ord, split //, $script);
$intcode->run;

my @output = @{ $intcode->output };
say map chr, @output[0 .. $#output - 1];
say $output[-1];
