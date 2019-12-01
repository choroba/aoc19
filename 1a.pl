#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

sub fuel { int($_[0] / 3) - 2 }


my $sum = 0;
while (<>) {
    $sum += fuel($_);
}
say $sum;

__END__

use Test::More tests => 4;
is fuel(12), 2;
is fuel(14), 2;
is fuel(1969), 654;
is fuel(100756), 33583;
