#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my $intcode = 'Intcode'->new;

my @in = split /,/, <>;
@in[1,2] = (12, 2);

$intcode->load(@in);
$intcode->run;
say $intcode->result;


__END__

use Test::More;

$intcode->load(1,9,10,3,2,3,11,0,99,30,40,50);
$intcode->run;
is_deeply $intcode->{src}, [3500,9,10,70,2,3,11,0,99,30,40,50];
$intcode->load(1,0,0,0,99);
$intcode->run;
is_deeply $intcode->{src}, [2,0,0,0,99];
$intcode->load(2,3,0,3,99);
$intcode->run;
is_deeply $intcode->{src}, [2,3,0,6,99];
$intcode->load(2,4,4,5,99,0);
$intcode->run;
is_deeply $intcode->{src}, [2,4,4,5,99,9801];
$intcode->load(1,1,1,4,99,5,6,0,99);
$intcode->run;
is_deeply $intcode->{src}, [30,1,1,4,2,5,6,0,99];

done_testing();
