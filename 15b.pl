#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use lib '.';
use Intcode;

my %MOVES = (1 => [  0, -1],
             2 => [  0,  1],
             3 => [ -1,  0],
             4 => [  1,  0]);

my %SHOW = ( 1  => ' ', 2 => ' ', 3 => ' ', 4 => '.', W => 'W', 5 => 'o',
             "" => '|', X => 'X' );

my @map;
my ($X, $Y) = (22, 22);
my ($x, $y) = ($X, $Y);
my %dispatch = (
    0 => sub { $map[ $y +  $MOVES{ $_[0] }[0] ]
                   [ $x +  $MOVES{ $_[0] }[1] ] = 'W' },
    2 => sub {       $y += $MOVES{ $_[0] }[0];
                     $x += $MOVES{ $_[0] }[1]; },
    1 => sub {       $y += $MOVES{ $_[0] }[0];
                     $x += $MOVES{ $_[0] }[1] });

my $intcode = 'Intcode'->new;
$intcode->load(split /,/, <>);
$intcode->pause(1);
my @path;
my $back;
my @oxygen;
while (1) {
    my $move = ($map[$y][$x] // 0) + 1;
    $back = 1, $move = pop @path
        if $move > 4;
    last unless $move;

    $intcode->input($move);
    $intcode->run;
    my $status = $intcode->output->[-1];
    my ($m, $n) = ($x, $y);
    $dispatch{$status}->($move);
    @oxygen = ($m, $n) if 2 == $status;
    ++$map[$n][$m] if ($map[$n][$m] // 0) < 4;
    push @path, $move + 2 * ($move % 2) - 1
            if $status > 0 && ! $back;
    undef $back;
}

my $free = 0;
for my $i (0 .. 42) {
    for my $j (0 .. 42) {
        ++$free if ($map[$j][$i] // "") eq 4;
    }
}

$map[ $oxygen[1] ][ $oxygen[0] ] = 5;
my $steps = 0;
while ($free > 1) {
    my @next;
    ++$steps;
    for my $i (0 .. 42) {
        for my $j (0 .. 42) {
            if (($map[$j][$i] // "") eq 5) {
                for my $move (1 .. 4) {
                    my $y = $j + $MOVES{$move}[0];
                    my $x = $i + $MOVES{$move}[1];
                    push @next, $y, $x
                        if ($map[$y][$x] // "") eq 4;
                }
            }
        }
    }

    while (($y, $x) = splice @next, 0, 2) {
        next if $map[$y][$x] == 5;
        $map[$y][$x] = 5;
        --$free;
    }

    # for my $i (0 .. 42) {
    #     for my $j (0 .. 42) {
    #         print(
    #             ($X == $i && $Y == $j)                 ? 'S'
    #           : ($i == $oxygen[0] && $j == $oxygen[1]) ? 'O'
    #           : ($SHOW{ $map[$j][$i] // "" } ));
    #     }
    #     print "\n";
    # }
    # select undef, undef, undef, .05;
}
say 1 + $steps;
