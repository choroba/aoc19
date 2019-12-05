package Intcode;

use warnings;
use strict;

sub new     { bless { src => [], ip => 0 }, shift }
sub load    { $_[0]{src} = [ @_[1 .. $#_] ]; $_[0]->restart }
sub ip      { $_[0]{ip} }
sub restart { $_[0]{ip} = 0 }
sub current { $_[0]{src}[ $_[0]{ip} ] }
sub result  { $_[0]{src}[0] }
sub forward { $_[0]{ip} += $_[1] + 1 }
sub input   { $_[0]{input} = [ @_[1 .. $#_] ] }
sub read    { shift @{ $_[0]{input} } }
sub print   { push @{ $_[0]{output} }, @_[1 .. $#_] }
sub output  { $_[0]{output} }

my %mode = (
    0 => sub { $_[0]{src}[ $_[1] ] },
    1 => sub { $_[1] });


my %instruction = (
    1 => { argc => 3,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[2] }->($self, $self->ip + 3) ]
                   = $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                   + $self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ] } },
    2 => { argc => 3,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[2] }->($self, $self->ip + 3) ]
                   = $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                   * $self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ] } },
    3 => { argc => 1,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                   = $self->read; } },
    4 => { argc => 1,
           action => sub {
               my ($self, @modes) = @_;
               $self->print(
                   $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ] )
           } },
);

sub run {
    while ((my $inst = $_[0]->current) != 99) {
        my @modes = reverse split //, int($inst / 100);
        $inst %= 100;
        push @modes, (0) x ($instruction{$inst}{argc} - @modes);
        my $action = $instruction{$inst}{action}
            or die "Invalid instruction $inst at " . $_[0]->ip . ".\n";
        $action->($_[0], @modes);
        $_[0]->forward($instruction{$inst}{argc});
    }
}

__PACKAGE__
