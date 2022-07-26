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

#===  FUNCTION  ================================================================
#{{{1     NAME: new
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
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
            my $title = "x:$row y:$col";
            $Board[$row][$col] = KeenCell->new($boardSize, $title);
            print ".";
        }
    }

    $self->{'board'} = \@Board;



    bless $self, $class;
    
    return $self;
}   # end of new



#===  FUNCTION  ================================================================
#{{{1     NAME: setCellState
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
    
    #print $Board[ $row ][ $col ]->toPrint();
    $Board[ $row ][ $col ]->setCellState( $state );
    #print $Board[ $row ][ $col ]->toPrint();

}   # end of setCellState


#===  FUNCTION  ================================================================
#{{{1     NAME: defineCellRelation
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub defineCellRelation {
    my $self     = shift;
    my $equation = shift;
    my @partners = @_;

    my @Board = @{$self->{'board'}} ;
    my $numberOfPartners  = scalar @partners;

    #print Data::Dumper->Dump( [\@partners, \$numberOfPartners],  [ qw( partners numberOfPartners ) ] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[0], ],  [ qw( partners ) ] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[0][0], ],  [ qw( partners ) ] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[0][1], ],  [ qw( partners ) ] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[1], ],  [ qw( partners )] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[2], ],  [ qw( partners )] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[2][0], ],  [ qw( partners ) ] ) . "\n";
    #print Data::Dumper->Dump( [\$partners[2][1], ],  [ qw( partners ) ] ) . "\n";


    if ( $numberOfPartners == 2) {
        $Board[ $partners[0][1] ][ $partners[0][0] ]->setMathEquation( $equation, $Board[ $partners[1][1] ][ $partners[1][0] ]);
        $Board[ $partners[1][1] ][ $partners[1][0] ]->setMathEquation( $equation, $Board[ $partners[0][1] ][ $partners[0][0] ]);
    } elsif ( $numberOfPartners == 3) {
        $Board[ $partners[0][1] ][ $partners[0][0] ]->setMathEquation( $equation, $Board[ $partners[1][1] ][ $partners[1][0] ],$Board[ $partners[2][1] ][ $partners[2][0] ],);
        $Board[ $partners[1][1] ][ $partners[1][0] ]->setMathEquation( $equation, $Board[ $partners[0][1] ][ $partners[0][0] ],$Board[ $partners[2][1] ][ $partners[2][0] ],);
        $Board[ $partners[2][1] ][ $partners[2][0] ]->setMathEquation( $equation, $Board[ $partners[0][1] ][ $partners[0][0] ],$Board[ $partners[1][1] ][ $partners[1][0] ],);
    } elsif ( $numberOfPartners == 4) {
        $Board[ $partners[0][1] ][ $partners[0][0] ]->setMathEquation( $equation, $Board[ $partners[1][1] ][ $partners[1][0] ],$Board[ $partners[2][1] ][ $partners[2][0] ],$Board[ $partners[3][1] ][ $partners[3][0] ],);
        $Board[ $partners[1][1] ][ $partners[1][0] ]->setMathEquation( $equation, $Board[ $partners[0][1] ][ $partners[0][0] ],$Board[ $partners[2][1] ][ $partners[2][0] ],$Board[ $partners[3][1] ][ $partners[3][0] ],);
        $Board[ $partners[2][1] ][ $partners[2][0] ]->setMathEquation( $equation, $Board[ $partners[0][1] ][ $partners[0][0] ],$Board[ $partners[1][1] ][ $partners[1][0] ],$Board[ $partners[3][1] ][ $partners[3][0] ],);
        $Board[ $partners[3][1] ][ $partners[3][0] ]->setMathEquation( $equation, $Board[ $partners[0][1] ][ $partners[0][0] ],$Board[ $partners[1][1] ][ $partners[1][0] ],$Board[ $partners[2][1] ][ $partners[2][0] ],);
    }


}   # end of defineCellRelation


#===  FUNCTION  ================================================================
#{{{1     NAME: solveByMath
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub solveByMath {
    my $self = shift; 
    my $boardSize = $self->{'N'};

    my $row=0;
    my $col=0;

    my @Board = @{$self->{'board'}} ;

    for( $row=$boardSize-1; $row > -1; $row-- ) {
            for( $col=0; $col< $boardSize; $col++ ) {
                 $Board[$row][$col]->solveByMath( );
            }
    }

    return ;

}   # end of solveByMath



#===  FUNCTION  ================================================================
#{{{1     NAME: printTitles
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub printTitles {
    my $self = shift; 
    my $boardSize = $self->{'N'};
    my $printSize = 9 * $boardSize + 1;

    my $row=0;
    my $col=0;

    my @Board = @{$self->{'board'}} ;
    my $retString;

    $retString .= "-" x $printSize . "\n" . "|";
    for( $row=$boardSize-1; $row > -1; $row-- ) {
            for( $col=0; $col< $boardSize; $col++ ) {
                 $retString .= $Board[$row][$col]->printTitle( ) . " |";
            }
        $retString .= "\n" . "-" x $printSize . "\n" . "|";
    }

    return $retString;

}   # end of printTitles


#===  FUNCTION  ================================================================
# {{{1    NAME: printEquations
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub printEquations {
    my $self = shift; 
    my $boardSize = $self->{'N'};
    my $printSize = 8 * $boardSize + 1;

    my $row=0;
    my $col=0;

    my @Board = @{$self->{'board'}} ;
    my $retString;

    $retString .= "-" x $printSize . "\n" ;
    for( $row=$boardSize-1; $row > -1; $row-- ) {
            for( $col=0; $col< $boardSize; $col++ ) {
                 $retString .= "| " . $Board[$row][$col]->printEquations( ) . " ";
             }
            $retString .= "|\n";
            $retString .= "-" x $printSize . "\n" ;
        }
        #$retString .= "-" x $printSize . "\n" . "|";

    return $retString;

}   # end of printEquations

#===  FUNCTION  ================================================================
#{{{1     NAME: printBoard
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
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
    for( $row=$boardSize-1; $row > -1; $row-- ) {
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

}   # end of printBoard


#===  FUNCTION  ================================================================
#{{{1     NAME: toPrint                      
#      PURPOSE:   
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub toPrint {
    my $self = shift;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Purity   = 1;  ##new to verify this

    return Dumper(\$self);
}   # end of toPrint
 


1;
##################################################################
#
#
#
##################################################################

# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:
