#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my @commands = qw(AND OR NOT);
my @read = qw(A B C D J T);
my @write = qw(J T);

my @program = split /,/, <>;

my $intcode;
while (1) {
    $intcode = 'Intcode'->new;
    $intcode->load(@program);
    my $script = "";
    for (1 .. int rand 16) {
        $script .= join ' ', $commands[rand @commands],
                             $read[rand @read],
                             $write[rand @write];
        $script .= "\n";
    }
    $script .= "WALK\n";

    say $script;

    $intcode->input(map ord, split //, $script);
    $intcode->run;

    my $output = join "", map chr, @{ $intcode->output };
    last if $output !~ /Didn't make it across/;
}
my @output = @{ $intcode->output };
say map chr, @output[0 .. $#output - 1];
say $output[-1];

__END__
OR A T
NOT C J
AND D J
NOT T T
OR T J
OR T T
NOT D T
NOT T T
AND C T
WALK
