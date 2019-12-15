#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my %MOVES = (1 => [-1,  0],
             2 => [ 1,  0],
             3 => [ 0, -1],
             4 => [ 0,  1]);

my @map;
my ($X, $Y) = (22, 50);
my ($x, $y) = ($X, $Y);
my %dispatch = (
    0 => sub { $map[ $y +  $MOVES{ $_[0] }[0] ]
                   [ $x +  $MOVES{ $_[0] }[1] ] = 'W' },
    1 => sub { $map[ $y += $MOVES{ $_[0] }[0] ]
                   [ $x += $MOVES{ $_[0] }[1] ] = ' ' },
    2 => sub { $map[ $y +  $MOVES{ $_[0] }[0] ]
                   [ $x +  $MOVES{ $_[0] }[1] ] = 'X' });

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
#$intcode->debug(1);
$intcode->pause(1);
$map[$y][$x] = ' ';
my @path;
while (1) {

    my $move;
    my @possible;
    for my $try (1 .. 4) {
        $move = $try unless $map[ $y + $MOVES{$try}[0] ][ $x + $MOVES{$try}[1] ];
    }
    print $move // '?', ' ';
    my $back;
    unless (defined $move) {
        $move = pop @path || 1 + int rand 4;
        $back = 1;
    }
    say $move;
    $intcode->input($move);
    $intcode->run;
    my $status = $intcode->output->[-1];
    $dispatch{$status}->($move);
    push @path, $move + 2 * ($move % 2) - 1 if ! $back && 1 == $status;

    for my $i (0 .. 50) {
        for my $j (0 .. 100) {
            print   (($x == $i && $y == $j) ? 'D'
                   : ($X == $i && $Y == $j) ? 'S'
                                            : ($map[$j][$i] // '.'));
        }
        print "\n";
    }
    select undef, undef, undef, .01;
    last if $status == 2;
}


