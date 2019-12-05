#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $int = 'Intcode'->new;
$int->load(split /,/, <>);
$int->input(1);
$int->run;
say for @{ $int->output };
