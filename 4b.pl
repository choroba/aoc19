#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

sub compliant {
    my ($password) = @_;
    return unless $password =~ /^[0-9]{6}$/;
    return unless $password =~ /(.)\1/;
    return if $password =~ /10|2[10]|3[210]|4[0-3]|5[0-4]|6[0-5]
                           |7[0-6]|8[0-7]|9[0-8]/x;
    while ($password =~ /(.)\1/g) {
        return 1 if "$password" !~ /$1{3}/;
    }
    return
}

chomp( my $range = <> );
my ($from, $to) = split /-/, $range;
my $count = 0;
for ($from .. $to) {
    ++$count if compliant($_);
}
say $count;

__END__

use Test::More;

ok(! compliant('111111'));
ok(! compliant('223450'));
ok(! compliant('123789'));
ok(compliant('112233'));
ok(! compliant('123444'));
ok(compliant('112222'));
ok(compliant('111122'));

done_testing();
