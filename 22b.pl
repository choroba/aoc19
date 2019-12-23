#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Math::BigInt;

use constant {
    MAX   => 'Math::BigInt'->new('119315717514047'),
    STEPS => 'Math::BigInt'->new('101741582076661'),
    CARD  => 'Math::BigInt'->new('2020'),
};

my @program = <>;

sub execute {
    my ($action, $calc) = @_;
    if ($action =~ /^deal into new/) {
        $calc->[0]->bmul(-1);
        $calc->[1]->badd(1)->bmul(-1);

    } elsif ($action =~ /^deal with increment (\d+)/) {
        my $amount = 'Math::BigInt'->new("$1");
        my $p = $amount->copy->bmodpow(MAX->copy->bsub(2), MAX);
        $_->bmul($p) for @$calc;

    } elsif ($action =~ /^cut (-?\d+)/) {
        my $amount = 'Math::BigInt'->new("$1");
        $calc->[1]->badd($amount);
    }
}

my @calc = map 'Math::BigInt'->new($_), qw( 1 0 );
for my $m (reverse @program) {
    execute($m, \@calc);
    $_->bmod(MAX) for @calc;
}
my $pow = $calc[0]->copy->bmodpow(STEPS, MAX);
my $r =  $pow->copy->bmul(CARD)
    ->badd($calc[1]
           ->bmul($pow->copy->badd(MAX)->bsub(1))
           ->bmul($calc[0]->copy->bsub(1)->bmodpow(MAX->copy->bsub(2), MAX)))
    ->bmod(MAX);

say $r;
