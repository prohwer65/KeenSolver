#
#===============================================================================
#
#         FILE: KeenCell.pm
#
#  DESCRIPTION: Object of a Keen Game cell.   Keen is a Suduko-like puzzle with
#               4x4 to 9x9 cells.   Cells can have a mathimatical relationship, ie 
#               "4x", 4+, 12x, etc.  to  help solve the puzzle. 
#
#               Cells can be in a couple of states:  solved or unsolved.
#               In the unsolved state, they can have N pencil marks or possible values. 
#               Where N matches the number of rows/columns, 4x4 is N = 4, or 1,2,3,4.  
#  
#               Upon Initialization, the cell can have all N possibilities.
#               After it is solved, the coll can only have that possibility. 
#
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer@mindspring.com
# ORGANIZATION: PowerAudio
#      VERSION: 1.0
#      CREATED: 03/11/20 17:42:49
#     REVISION: ---
#===============================================================================





package KeenCell; 

use strict;
use warnings;
use Data::Dumper;

use Readonly; 

use lib qw ( . lib );
#use parent 'myParentOOP';

Readonly my $alreadySolved =>  10;
Readonly my $justSolved    =>  1;
Readonly my $notSolved     =>  0;




my $DEBUGLEVEL = 0;


#=== {{{1     SUBROUTINE FUNCTIONS  ================================================================
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
    $self->{'title'} = shift;

    die "You must define the number of possible states for this cell"  if ( !defined $Ncells ) ;
    die "Please keep the number of cells less than 10"   if ( $Ncells > 9);
    die "The number of cells needs to be greater than 2"   if ( $Ncells < 1);
    die "Please provide a name for the cell (ie X:0 Y:0) " if ( !defined $self->{'title'});
    
    $self->{'possible'} = [1 .. $Ncells];
    $self->{'solved'}   = 0;
    $self->{'N'} = $Ncells;


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

    my $state= shift || " ";
    if ( $state < 1 || $state > $self->{'N'}  ) {
            print "invalid state ($state) attempted";
            die;
    }

    $self->{'possible'} =  undef;
    $self->{'possible'}[0] = $state;
    $self->{'solved'} = 1;

    return     $self->{'possible'} ;
}   # end of setCellState


#===  FUNCTION  ================================================================
#{{{1     NAME: isCellSolved
#      PURPOSE: check to see if the cell has been solved or not. 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub isCellSolved {
    my $self = shift;
    return     $self->{'solved'} ;
}   # end of isCellSolved

#===  FUNCTION  ================================================================
#{{{1     NAME: setMathEquation
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setMathEquation {

    my $self        = shift;
    my $keenMath    = shift;     # "+4", "-4", "x8", "/2",  math equation for this cell and partner(s).

    my @mathPartners = @_;
    $self->{'mathPartners'} = \@mathPartners;

    if ( $keenMath =~ /([-+xd])(\d+)/ ) {
        #print "-+xd  dd   ";
        $self->{'operator'} = $1;
        $self->{'solution'} = $2;
    } elsif ( $keenMath =~ /(\d+)([-+xd])/ ) {
        #print "dd  -+xd  ";
        $self->{'solution'} = $1;
        $self->{'operator'} = $2;
    } else {
        die "Unknown equation ($keenMath).";
    }
    #print "$keenMath  = $self->{'solution'} $self->{'operator'} \n";

}   # end of setMathEquation


#===  FUNCTION  ================================================================
#{{{1     NAME: getOperator
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getOperator {
    my $self        = shift;
    return $self->{'operator'};
}   # end of getOperator

#===  FUNCTION  ================================================================
#{{{1     NAME: getSolution
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getSolution {
    my $self        = shift;
    return $self->{'solution'};
}   # end of getSolution


#===  FUNCTION  ================================================================
#{{{1     NAME: numberOfPartners
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub numberOfPartners {
    my $self        = shift;

    my @tmp = @{  $self->{'mathPartners'} };
    return scalar (  @tmp );

}   # end of numberOfPartners
#===  FUNCTION  ================================================================
#{{{1     NAME: getRefOfCellPencilMarks
#      PURPOSE: returns a reference to an array of the pencil marks for that cell.
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getRefOfCellPencilMarks {
    my $self = shift;
    return     \$self->{'possible'} ;
}   # end of getRefOfCellPencilMarks

#===  FUNCTION  ================================================================
#{{{1     NAME: getArrayOfCellPencilMarks
#      PURPOSE: returns an array of the pencil marks for that cell.
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getArrayOfCellPencilMarks {
    my $self = shift;
    return     $self->{'possible'} ;
}   # end of getArrayOfCellPencilMarks


#===  FUNCTION  ================================================================
#{{{1     NAME: getCellsAnswer
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCellsAnswer {
    my $self = shift;
    return     $self->{'possible'}[0];
} # end of getCellsAnswer


#===  FUNCTION  ================================================================
#{{{1     NAME: removeValues
#      PURPOSE: As pencil marks are eliminated, call this method with those values.
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub removeValues {

    my $self = shift;
    my @toBeRemoved= @_;

    return 1 if ( $self->{'solved'} == 1 );

    my @workingArray = @{ $self->{'possible'} };     # working array 

    foreach my $v ( @toBeRemoved ) {
        @workingArray = grep { !/$v/}  @workingArray ;
        #print Data::Dumper->Dump( [ $v, \@workingArray, ] , [ qw( V Array ) ] ) . "\n";
    }


    $self->{'possible'} = \@workingArray;

    if ( scalar( @workingArray) == 1) {
        $self->{'solved'} = 1;
    }
    if ( scalar( @workingArray) == 0) {
        warn "ERROR:  Removed all the possiblities ";
    }

    return( scalar( @workingArray) );

}   # end of removeValues


#===  FUNCTION  ================================================================
#{{{1     NAME: numberPencils
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub numberPencils {
    my $self = shift;
    
    return ( scalar ( @{ $self->{'possible'} }) );
}   # end of numberPencils


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
    my $self           = shift;
    #my $keenMath       = shift;     # "+4", "-4", "x8", "/2",  math equation for this cell and partner(s).
    my $numberOfPartners = $self->numberOfPartners();

    my @partners = @{  $self->{'mathPartners'} };

    if ( ! defined $self->{'operator'} ) {
        die "Math Equation is not defined (operator) ";
    }
    if ( ! defined $self->{'solution'} ) {
        die "Math Equation is not defined (solution). ";
    }
    
    if      ( $self->{'operator'} eq "+" && $numberOfPartners==1) { $self->tryMathAdd2( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "+" && $numberOfPartners==2) { $self->tryMathAddMulti3( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "+" && $numberOfPartners==3) { $self->tryMathAddMulti4( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "x" && $numberOfPartners==1) { $self->tryMathMulti2( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "x" && $numberOfPartners==2) { $self->tryMathAddMulti3( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "x" && $numberOfPartners==3) { $self->tryMathAddMulti4( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "-" && $numberOfPartners==1) { $self->tryMathSubtract2( $self->{'solution'}, @partners);
    } elsif ( $self->{'operator'} eq "d" && $numberOfPartners==1) { $self->tryMathDivide2( $self->{'solution'}, @partners);
    } else {
        die "Undefined operator ($self->{'operator'} ) or numberOfPartners ( $numberOfPartners)";
    }

    return ( scalar ( @{ $self->{'possible'} }) );
}   # end of solveByMath   # end of solveByMath




#===  FUNCTION  ================================================================
#{{{1     NAME: tryMathAdd2
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub tryMathAdd2 {
    my $self = shift;
    my $sum  = shift; 
    my @partners = @_;
    my @partnersValues = @{ $partners[0]->getArrayOfCellPencilMarks() };
    my $trackNumberOfChanges=0;

    #print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %pencilNeeded;         # hash of self's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededPartner;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.

    foreach my $a (  @{ $self->{'possible'} } ) {
        $pencilNeeded{$a}     = 0;
    }

    foreach my $a (  @partnersValues ) {
        $pencilNeededPartner{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            #print "Attempting to add $b and $a to see if equal $sum\n";
            if ( $sum == ($a + $b) )  { 
                $pencilNeeded{$a} = 1;
                $pencilNeededPartner{$b} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $pencilNeeded{$a}    == 0 ) {
            $self->removeValues( $a );
            $trackNumberOfChanges++;
        }
    }


    
    foreach my $b ( @partnersValues ) {
        if ( $pencilNeededPartner{$b}    == 0 ) {
            $partners[0]->removeValues( $b );
            $trackNumberOfChanges++;
        }
    }


}   # end of tryMathAdd2   # end of tryMathAdd2

#===  FUNCTION  ================================================================
#{{{1     NAME: tryMathAddMulti3
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub tryMathAddMulti3 {
    my $self = shift;
    my $sum  = shift; 
    my @partners = @_;
    my @partnersBValues = @{ $partners[0]->getArrayOfCellPencilMarks() };
    my @partnersCValues = @{ $partners[1]->getArrayOfCellPencilMarks() };
    my $trackNumberOfChanges=0;

    #print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %pencilNeeded;         # hash of self's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededB;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededC;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.

    foreach my $selfMarks (  @{ $self->{'possible'} } ) {
        $pencilNeeded{$selfMarks}     = 0;
    }

    foreach my $bMarks (  @partnersBValues ) {
        $pencilNeededB{$bMarks}     = 0;
    }
    
    foreach my $cMarks (  @partnersCValues ) {
        $pencilNeededC{$cMarks}     = 0;
    }


    foreach my $c ( @partnersCValues ) {
        foreach my $b ( @partnersBValues ) {
            foreach my $selfMarks (  @{ $self->{'possible'} } ) {
            #print "Attempting to add $b and $selfMarks to see if equal $sum\n";
                if ( $self->{'operator'} eq "+") {
                    if ( $sum == ($selfMarks + $b + $c ) )  { 
                        $pencilNeeded{$selfMarks} = 1;
                        $pencilNeededB{$b} = 1;
                        $pencilNeededC{$b} = 1;
                    }
                }
                if ( $self->{'operator'} eq "x") {
                    if ( $sum == ($selfMarks * $b * $c ) )  { 
                        $pencilNeeded{$selfMarks} = 1;
                        $pencilNeededB{$b} = 1;
                        $pencilNeededC{$b} = 1;
                    }
                }
            }
        }
    }

    
    foreach my $selfMarks (  @{ $self->{'possible'} } ) {
        if ( $pencilNeeded{$selfMarks}    == 0 ) {
            $self->removeValues( $selfMarks );
            $trackNumberOfChanges++;
        }
    }


    
    foreach my $b ( @partnersBValues ) {
        if ( $pencilNeededB{$b}    == 0 ) {
            $partners[0]->removeValues( $b );
            $trackNumberOfChanges++;
        }
    }


    
    foreach my $c ( @partnersCValues ) {
        if ( $pencilNeededC{$c}    == 0 ) {
            $partners[1]->removeValues( $c );
            $trackNumberOfChanges++;
        }
    }


}   # end of tryMathAddMulti3

#===  FUNCTION  ================================================================
#{{{1     NAME: tryMathAddMulti4
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub tryMathAddMulti4 {
    my $self = shift;
    my $sum  = shift; 
    my @partners = @_;
    my @partnersBValues = @{ $partners[0]->getArrayOfCellPencilMarks() };
    my @partnersCValues = @{ $partners[1]->getArrayOfCellPencilMarks() };
    my @partnersDValues = @{ $partners[2]->getArrayOfCellPencilMarks() };
    my $trackNumberOfChanges=0;

    #print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %pencilNeeded;         # hash of self's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededB;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededC;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededD;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.

    foreach my $selfMarks (  @{ $self->{'possible'} } ) {
        $pencilNeeded{$selfMarks}     = 0;
    }

    foreach my $bMarks (  @partnersBValues ) {
        $pencilNeededB{$bMarks}     = 0;
    }
    
    foreach my $cMarks (  @partnersCValues ) {
        $pencilNeededC{$cMarks}     = 0;
    }

    foreach my $dMarks (  @partnersDValues ) {
        $pencilNeededD{$dMarks}     = 0;
    }


    foreach my $d ( @partnersDValues ) {
    foreach my $c ( @partnersCValues ) {
        foreach my $b ( @partnersBValues ) {
            foreach my $selfMarks (  @{ $self->{'possible'} } ) {
            #print "Attempting to add $b and $selfMarks to see if equal $sum\n";
                if ( $self->{'operator'} eq "+") {
                    if ( $sum == ($selfMarks + $b + $c + $d ) )  { 
                        $pencilNeeded{$selfMarks} = 1;
                        $pencilNeededB{$b} = 1;
                        $pencilNeededC{$c} = 1;
                        $pencilNeededD{$d} = 1;
                    }
                }
                if ( $self->{'operator'} eq "x") {
                    if ( $sum == ($selfMarks * $b * $c * $d ) )  { 
                        $pencilNeeded{$selfMarks} = 1;
                        $pencilNeededB{$b} = 1;
                        $pencilNeededC{$c} = 1;
                        $pencilNeededD{$d} = 1;
                    }
                }
            }
        }
    }
    }

    
    foreach my $selfMarks (  @{ $self->{'possible'} } ) {
        if ( $pencilNeeded{$selfMarks}    == 0 ) {
            $self->removeValues( $selfMarks );
            $trackNumberOfChanges++;
        }
    }

    foreach my $b ( @partnersBValues ) {
        if ( $pencilNeededB{$b}    == 0 ) {
            $partners[0]->removeValues( $b );
            $trackNumberOfChanges++;
        }
    }

    foreach my $c ( @partnersCValues ) {
        if ( $pencilNeededC{$c}    == 0 ) {
            $partners[1]->removeValues( $c );
            $trackNumberOfChanges++;
        }
    }

    foreach my $d ( @partnersDValues ) {
        if ( $pencilNeededD{$d}    == 0 ) {
            $partners[2]->removeValues( $d );
            $trackNumberOfChanges++;
        }
    }



}   # end of tryMathAddMulti4

#===  FUNCTION  ================================================================
#{{{1     NAME: tryMathMulti2
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub tryMathMulti2 {
    my $self = shift;
    my $sum = shift; 

    my @partners = @_;
    my @partnersValues = @{ $partners[0]->getArrayOfCellPencilMarks() };
    my $trackNumberOfChanges=0;

    # print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";

    my %pencilNeeded;         # hash of self's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededPartner;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.

    foreach my $a (  @{ $self->{'possible'} } ) {
        $pencilNeeded{$a}     = 0;
    }

    foreach my $a (  @partnersValues ) {
        $pencilNeededPartner{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            #print "Attempting to add $b and $a to see if equal $sum\n";
            if ( $sum == ($a * $b) )  { 
                $pencilNeeded{$a} = 1;
                $pencilNeededPartner{$b} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $pencilNeeded{$a}    == 0 ) {
            $self->removeValues( $a );
            $trackNumberOfChanges++;
        }
    }


    
    foreach my $b ( @partnersValues ) {
        if ( $pencilNeededPartner{$b}    == 0 ) {
            $partners[0]->removeValues( $b );
            $trackNumberOfChanges++;
        }
    }


}   # end of tryMathMulti2




#===  FUNCTION  ================================================================
#{{{1     NAME: tryMathSubtract2
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub tryMathSubtract2 {
    my $self = shift;
    my $sum = shift; 

    my @partners = @_;
    my @partnersValues = @{ $partners[0]->getArrayOfCellPencilMarks() };
    my $trackNumberOfChanges=0;

    # print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %pencilNeeded;         # hash of self's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededPartner;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.

    foreach my $a (  @{ $self->{'possible'} } ) {
        $pencilNeeded{$a}     = 0;
    }

    foreach my $a (  @partnersValues ) {
        $pencilNeededPartner{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            #print "Attempting to add $b and $a to see if equal $sum\n";
            if ( $sum == ($a - $b) )  { 
                $pencilNeeded{$a} = 1;
                $pencilNeededPartner{$b} = 1;
            }
            if ( $sum == ($b - $a) )  { 
                $pencilNeeded{$a} = 1;
                $pencilNeededPartner{$b} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $pencilNeeded{$a}    == 0 ) {
            $self->removeValues( $a );
            $trackNumberOfChanges++;
        }
    }


    
    foreach my $b ( @partnersValues ) {
        if ( $pencilNeededPartner{$b}    == 0 ) {
            $partners[0]->removeValues( $b );
            $trackNumberOfChanges++;
        }
    }



}   # end of tryMathSubtract2


#===  FUNCTION  ================================================================
#{{{1     NAME: tryMathDivide2
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub tryMathDivide2 {
    my $self = shift;
    my $sum = shift; 

    my @partners = @_;
    my @partnersValues = @{ $partners[0]->getArrayOfCellPencilMarks() };
    my $trackNumberOfChanges=0;

    # print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %pencilNeeded;         # hash of self's pencil marks, will be used to flag if value is needed in math eq.
    my %pencilNeededPartner;  # hash of Partner's pencil marks, will be used to flag if value is needed in math eq.

    foreach my $a (  @{ $self->{'possible'} } ) {
        $pencilNeeded{$a}     = 0;
    }

    foreach my $a (  @partnersValues ) {
        $pencilNeededPartner{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            #print "Attempting to add $b and $a to see if equal $sum\n";
            if ( $sum == ($a / $b) )  { 
                $pencilNeeded{$a} = 1;
                $pencilNeededPartner{$b} = 1;
            }
            if ( $sum == ($b / $a) )  { 
                $pencilNeeded{$a} = 1;
                $pencilNeededPartner{$b} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $pencilNeeded{$a}    == 0 ) {
            $self->removeValues( $a );
            $trackNumberOfChanges++;
        }
    }


    
    foreach my $b ( @partnersValues ) {
        if ( $pencilNeededPartner{$b}    == 0 ) {
            $partners[0]->removeValues( $b );
            $trackNumberOfChanges++;
        }
    }


}   # end of tryMathDivide2


#===  FUNCTION  ================================================================
#{{{1     NAME: printCell
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#          Solved cell:    | 2 2 2 
#                          | 2 2 2 
#                          | 2 2 2 
#
#          Unsolved cell:  | 1   3 
#                          |   5
#                          |     9
#
#===============================================================================
sub printCell {
    my $self = shift;
    my $row  = shift;     # which row is being printed  

    if ( not defined $row) {
        die "function printCell() needs a value 0:2 to know which row of the cell to print\n";
    }
    my %hashOfPossible ;
    if ( $self ->{'solved'}  ) { 
        return ("| ". $self->{'possible'}[0] . " ". $self->{'possible'}[0] . " ". $self->{'possible'}[0] . " ");
    }
    
    foreach my $a (  @{ $self->{'possible'} } ) {
        $hashOfPossible{$a-1}     = 1;
    }

    my $string = "| ";
    for( my $i=$row*3 ; $i< (($row*3)+3); $i++) {
        if ( $hashOfPossible{ $i} ) {
            $string .= $i+1 . " ";
        } else {
                $string .= "  ";
        }
    }

    return $string;

}   # end of printCell



#===  FUNCTION  ================================================================
#{{{1     NAME: printFullCell
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub printFullCell {

    my $self = shift;

    my $string = $self->printCell(0).  " |row 0 for " . $self->printTitle() . "\n";
    $string   .= $self->printCell(1).  " |row 1 eq  " . $self->getOperator() . $self->getSolution() . "\n";
    $string   .= $self->printCell(2).  " |row 2 \n";

    return $string;
}   # end of printFullCell()

#===  FUNCTION  ================================================================
#{{{1     NAME: printEquations
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

    my $retStr = sprintf( " %2d%s ",  ($self->{'solution'} || "  ") , ($self->{'operator'} || " ")) ;
    return $retStr;
}   # end of printEquations

#===  FUNCTION  ================================================================
#{{{1     NAME: printTitle
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub printTitle {
    my $self = shift;
    return $self->{'title'} || "no title";
}   # end of printTitle

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

    my $title = $self->{'title'};

    return Data::Dumper->Dump( [\$self],  [$title ] ) . "\n";
    #return Dumper(\$self);
}   # end of toPrint


1;

# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:
