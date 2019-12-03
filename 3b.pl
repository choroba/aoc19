#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };
use Syntax::Construct qw{ // };

my %VECTOR = ( U => [ 0, -1],
               D => [ 0,  1],
               L => [-1,  0],
               R => [ 1,  0]);
sub fewest_steps {
    my (@wires) = @_;
    my %grid;
    my $closest;
    for my $wire_index (1, 2) {
        my @moves = split /,/, $wires[ $wire_index - 1 ];
        my ($x, $y) = (0, 0);
        my $step = 1;
        for my $move (@moves) {
            my ($direction, $length) = $move =~ /(.)(.*)/;
            for my $i (1 .. $length) {
                $x += $VECTOR{$direction}[0];
                $y += $VECTOR{$direction}[1];
                $grid{$x}{$y}{who} |= $wire_index;
                $grid{$x}{$y}{step}{$wire_index} //= $step;
                if ($grid{$x}{$y}{who} == 3) {
                    my $distance
                        = $grid{$x}{$y}{step}{1} + $grid{$x}{$y}{step}{2};
                    $closest = $distance if ! defined $closest
                                         || $distance < $closest;
                }
                ++$step;
            }
        }
    }
    return $closest
}

say fewest_steps(<>);

__END__

use Test::More;

is fewest_steps('R8,U5,L5,D3', 'U7,R6,D4,L4'), 30;
is fewest_steps('R75,D30,R83,U83,L12,D49,R71,U7,L72',
                'U62,R66,U55,R34,D71,R55,D58,R83'), 610;
is fewest_steps('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51',
                'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'), 410;
done_testing();
