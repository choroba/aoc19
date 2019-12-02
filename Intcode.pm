package Intcode;

use warnings;
use strict;

sub new  { bless { src => [], ip => 0 }, shift }
sub load { $_[0]{src} = [ @_[1 .. $#_] ]; $_[0]{ip} = 0 }

my %dispatch = (
    1 => sub {
        $_[0]{src}[ $_[0]{src}[$_[0]{ip} + 3] ]
            = $_[0]{src}[ $_[0]{src}[$_[0]{ip} + 1] ]
            + $_[0]{src}[ $_[0]{src}[$_[0]{ip} + 2] ] },
    2 => sub {
        $_[0]{src}[ $_[0]{src}[$_[0]{ip} + 3] ]
            = $_[0]{src}[ $_[0]{src}[$_[0]{ip} + 1] ]
            * $_[0]{src}[ $_[0]{src}[$_[0]{ip} + 2] ] } );
sub run {
    while ((my $instruction = $_[0]{src}[ $_[0]{ip} ]) != 99) {
        my $action = $dispatch{$instruction}
            or die "Invalid instruction $instruction at $_[0]{ip}.\n";
        warn ": @{ $_[0]{src} }[ $_[0]{ip} .. $_[0]{ip} + 3]...\n";
        $action->($_[0]);
        $_[0]{ip} += 4;
    }
}

sub result { $_[0]{src}[0] }

__PACKAGE__
