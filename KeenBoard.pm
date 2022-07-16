#
#===============================================================================
#
#         FILE: KeenBoard.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer@mindspring.com
# ORGANIZATION: PowerAudio
#      VERSION: 1.0
#      CREATED: 6/23/2022 12:08:57 PM
#     REVISION: ---
#===============================================================================

 
package KeenBoard;

use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use KeenCell;
use Data::Dumper;

#use parent 'myParentOOP';

has 'name'       => ( is => 'ro', isa => "Str" );

##############################################################################
sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self; 
    my $Ncells= shift;

    die "You must define the number of possible states for this cell"  if ( !defined $Ncells ) ;
    
    $self->{'N'} = $Ncells;
    my @Board;

    my $row=0;    # row
    my $col=0;    # col
    my $printRow;

    my $boardSize = $Ncells;

    for( $row=0; $row< $boardSize; $row++ ) {
        for( $col=0; $col< $boardSize; $col++ ) {
            $Board[$row][$col] = KeenCell->new($boardSize);
            print ".";
        }
    }

    $self->{'board'} = \@Board;



    bless $self, $class;
    
    return $self;
}



#===  FUNCTION  ================================================================
#         NAME: setCellState
#      PURPOSE: When a cell's state is known, call this method with that value. 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setCellState {
    my $self = shift;
    my $row  = shift;
    my $col  = shift;
    my $state= shift || " ";

    if ( $state < 1 || $state > $self->{'N'}  ) {
        print "invalid state ($state) attempted";
        die;
    }

    my @Board = @{$self->{'board'}} ;
    
    print $Board[ $row ][ $col ]->toPrint();
    $Board[ $row ][ $col ]->setCellState( $state );
    print $Board[ $row ][ $col ]->toPrint();

}




sub printBoard {
    my $self = shift; 
    my $boardSize = $self->{'N'};
    my $printSize = 8 * $boardSize + 1;

    my $row=0;
    my $col=0;
    my $printRow;

    my @Board = @{$self->{'board'}} ;
    my $retString;

    $retString .= "-" x $printSize . "\n";
    for( $row=0; $row< $boardSize; $row++ ) {
        for( $printRow=0; $printRow < 3; $printRow++) {
            for( $col=0; $col< $boardSize; $col++ ) {
                 $retString .= $Board[$row][$col]->printCell( $printRow);
            }
            $retString .= "|\n";
        }
        $retString .= "-" x $printSize . "\n";
    }
    #$retString .= "-" x $printSize . "\n";

    return $retString;

}
sub toPrint {
    my $self = shift;

    return Dumper(\$self);
}
 


1;
##################################################################
#
#
#
##################################################################

# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround
