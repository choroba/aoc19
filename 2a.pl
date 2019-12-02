#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my @src;
my $pc;

my %dispatch = ( 1 => sub { $src[ $src[$pc + 3] ]
                           = $src[ $src[$pc + 1] ] + $src[ $src[$pc + 2] ] },
                 2 => sub { $src[ $src[$pc + 3] ]
                           = $src[ $src[$pc + 1] ] * $src[ $src[$pc + 2] ] } );

sub run {
    @src = @_;
    $pc = 0;
    while ($src[$pc] != 99) {
        my $action = $dispatch{ $src[$pc] }
            or die "Invalid instruction $src[$pc] at $pc.";
        $action->();
        $pc += 4;
        warn "$pc...\n";
    }
    return \@src
}

my @in = split /,/, <>;
@in[1,2] = (12, 2);
run(@in);
say $src[0];

__END__

use Test::More;

is_deeply run(1,9,10,3,2,3,11,0,99,30,40,50), [3500,9,10,70,2,3,11,0,99,30,40,50];
is_deeply run(1,0,0,0,99), [2,0,0,0,99];
is_deeply run(2,3,0,3,99), [2,3,0,6,99];
is_deeply run(2,4,4,5,99,0), [2,4,4,5,99,9801];
is_deeply run(1,1,1,4,99,5,6,0,99), [30,1,1,4,2,5,6,0,99];
done_testing();
