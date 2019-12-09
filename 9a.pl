#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
$intcode->input(1);
$intcode->run;
say "@{ $intcode->output }";
