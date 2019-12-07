package Intcode;

use warnings;
use strict;
use feature qw{ say };

sub new      { bless { src => [], ip => 0 }, shift }
sub load     { $_[0]{src} = [ @_[1 .. $#_] ]; $_[0]->restart }
sub ip       { $_[0]{ip} }
sub jump     { $_[0]{ip} = $_[1] }
sub restart  { $_[0]{ip} = 0 }
sub current  { $_[0]{src}[ $_[0]{ip} ] }
sub result   { $_[0]{src}[0] }
sub forward  { $_[0]{ip} += $_[1] + 1 }
sub input    { $_[0]{input} = [ @_[1 .. $#_] ] }
sub read     { shift @{ $_[0]{input} } }
sub print    { push @{ $_[0]{output} }, @_[1 .. $#_] }
sub output   { $_[0]{output} }
sub finished { $_[0]{finished} }

my %mode = (
    0 => sub { $_[0]{src}[ $_[1] ] },
    1 => sub { $_[1] });

my %instruction = (
    1 => { argc => 3,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[2] }->($self, $self->ip + 3) ]
                   = $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                   + $self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ];
               return ""
           } },
    2 => { argc => 3,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[2] }->($self, $self->ip + 3) ]
                   = $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                   * $self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ];
               return ""
           } },
    3 => { argc => 1,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                   = $self->read;
               return ""
           } },
    4 => { argc => 1,
           action => sub {
               my ($self, @modes) = @_;
               $self->print(
                   $self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ] );
               return ""
           } },
    5 => { argc => 2,
           action => sub {
               my ($self, @modes) = @_;
               if ($self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]) {
                   $self->jump($self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ]);
                   return 'jump'
               }
               return ""
           } },
    6 => { argc => 2,
           action => sub {
               my ($self, @modes) = @_;
               unless ($self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]) {
                   $self->jump($self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ]);
                   return 'jump'
               }
               return ""
           } },
    7 => { argc => 3,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[2] }->($self, $self->ip + 3) ]
                   = ($self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                      < $self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ])
                   ? 1 : 0;
               return ""
           } },
    8 => { argc => 3,
           action => sub {
               my ($self, @modes) = @_;
               $self->{src}[ $mode{ $modes[2] }->($self, $self->ip + 3) ]
                   = ($self->{src}[ $mode{ $modes[0] }->($self, $self->ip + 1) ]
                      == $self->{src}[ $mode{ $modes[1] }->($self, $self->ip + 2) ])
                   ? 1 : 0;
               return ""
           } },
);

sub run {
    while ((my $inst = $_[0]->current) != 99) {
        my @modes = reverse split //, int($inst / 100);
        $inst %= 100;
        push @modes, (0) x ($instruction{$inst}{argc} - @modes);
        my $action = $instruction{$inst}{action}
            or die "Invalid instruction $inst at " . $_[0]->ip . ".\n";
        # warn "@{ $_[0]{src} }";
        # say join ' ', @{ $_[0]{src} }[ $_[0]->{ip} .. $_[0]->{ip} + $instruction{$inst}{argc} ];
        my $result = $action->($_[0], @modes);
        $_[0]->forward($instruction{$inst}{argc}) unless $result eq 'jump';
    }
    $_[0]{finished} = 1;
}

__PACKAGE__
