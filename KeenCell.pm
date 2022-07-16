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
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer@micron.com
# ORGANIZATION: SpecTek
#      VERSION: 1.0
#      CREATED: 03/11/20 17:42:49
#     REVISION: ---
#===============================================================================





package KeenCell; 

use strict;
use warnings;
use Data::Dumper;

use Readonly; 


Readonly my $alreadySolved =>  10;
Readonly my $justSolved    =>  1;
Readonly my $notSolved     =>  0;




my $DEBUGLEVEL = 0;


##############################################################################
sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self; 
    my $Ncells= shift;

    die "You must define the number of possible states for this cell"  if ( !defined $Ncells ) ;
    
    $self->{'possible'} = [1 .. $Ncells];
    $self->{'solved'}   = 0;
    $self->{'N'} = $Ncells;


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

    my $state= shift || " ";
    if ( $state < 1 || $state > $self->{'N'}  ) {
            print "invalid state ($state) attempted";
            die;
        }
    $self->{'possible'} = $state;
    $self->{'solved'} = 1;

    return     $self->{'possible'} ;
}


#===  FUNCTION  ================================================================
#         NAME: isCellSolved
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
}


sub setMathEquation {

    my $self = shift;
    my $keenMath       = shift;     # "+4", "-4", "x8", "/2",  math equation for this cell and partner(s).

    if ( $keenMath =~ /([-+xd])(\d*)/ ) {

        $self->{'operator'} = $1;
        $self->{'solution'} = $2;

    } else {
        die "Unknown equation ($keenMath).";
    }

}
#===  FUNCTION  ================================================================
#         NAME: getCellStates
#      PURPOSE: return an array of the pencil marks for that cell.
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCellStates {
    my $self = shift;
    return     \$self->{'possible'} ;
}



#===  FUNCTION  ================================================================
#         NAME: removeValues
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

}


sub numberPencils {
    my $self = shift;
    
    return ( scalar ( @{ $self->{'possible'} }) );
}

sub solveByMath {
    my $self           = shift;
    #my $keenMath       = shift;     # "+4", "-4", "x8", "/2",  math equation for this cell and partner(s).
    my @partnersValues = @_;

    if ( ! defined $self->{'operator'} ) {
        die "Math Equation is not defined (operator) ";
    }
    if ( ! defined $self->{'solution'} ) {
        die "Math Equation is not defined (solution). ";
    }
    
    if ( $self->{'operator'} eq "+" ) {
       $self->tryMathAdd( $self->{'solution'}, @partnersValues );
    } elsif ( $self->{'operator'} eq "-" ) {
        $self->tryMathSubtract( $self->{'solution'}, @partnersValues );
    } elsif ( $self->{'operator'} eq "x" ) {
        $self->tryMathMulti( $self->{'solution'}, @partnersValues );
    } elsif ( $self->{'operator'} eq "d" ) {
        $self->tryMathDivide( $self->{'solution'}, @partnersValues );
    }

    return ( scalar ( @{ $self->{'possible'} }) );
}



sub tryMathAdd {
    my $self = shift;
    my $sum = shift; 
    my @partnersValues = @_;

    #print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %hashSolved;

    foreach my $a (  @{ $self->{'possible'} } ) {
        $hashSolved{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            if ( $sum == ($a + $b) )  { 
                $hashSolved{$a} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $hashSolved{$a}    == 0 ) {
            $self->removeValues( $a );
        }
    }


}

sub tryMathMulti {
    my $self = shift;
    my $sum = shift; 
    my @partnersValues = @_;

    # print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %hashSolved;

    foreach my $a (  @{ $self->{'possible'} } ) {
        $hashSolved{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            if ( $sum == ($a * $b) )  { 
                $hashSolved{$a} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $hashSolved{$a}    == 0 ) {
            $self->removeValues( $a );
        }
    }


}




sub tryMathSubtract {
    my $self = shift;
    my $sum = shift; 
    my @partnersValues = @_;

    # print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %hashSolved;

    foreach my $a (  @{ $self->{'possible'} } ) {
        $hashSolved{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            if ( $sum == ($a - $b) )  { 
                $hashSolved{$a} = 1;
            }
            if ( $sum == ($b - $a) )  { 
                $hashSolved{$a} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $hashSolved{$a}    == 0 ) {
            $self->removeValues( $a );
        }
    }


}


sub tryMathDivide {
    my $self = shift;
    my $sum = shift; 
    my @partnersValues = @_;

    # print Data::Dumper->Dump( [ $sum, \@partnersValues, ] , [ qw( sum partnersValues ) ] ) . "\n";
    my %hashSolved;

    foreach my $a (  @{ $self->{'possible'} } ) {
        $hashSolved{$a}     = 0;
    }

    foreach my $b ( @partnersValues ) {
        foreach my $a (  @{ $self->{'possible'} } ) {
            if ( $sum == ($a / $b) )  { 
                $hashSolved{$a} = 1;
            }
            if ( $sum == ($b / $a) )  { 
                $hashSolved{$a} = 1;
            }
        }
    }

    
    foreach my $a (  @{ $self->{'possible'} } ) {
        if ( $hashSolved{$a}    == 0 ) {
            $self->removeValues( $a );
        }
    }


}


#===  FUNCTION  ================================================================
#         NAME: printCell
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

    my %hashOfPossible ;
    if ( $self ->{'solved'}  ) { 
        return ("| ". $self->{'possible'} . " ". $self->{'possible'} . " ". $self->{'possible'} . " ");
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

}

sub toPrint {
    my $self = shift;

    return Dumper(\$self);
}


1;

# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround
