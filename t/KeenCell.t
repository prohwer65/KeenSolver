#!/usr/bin/perl
#===============================================================================
#
#         FILE: KeenCell.t
#
#  DESCRIPTION: j
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer@mindspring.com
# ORGANIZATION: PowerAudio
#      VERSION: 1.0
#      CREATED: 03/12/20 08:36:00
#     REVISION: ---
#===============================================================================

#use strict;
#use warnings;

use Data::Dumper;

use lib qw ( . .. );
use Test::More ;                      # last test to print
use Data::Compare;


my $numberOfTests=0;
use_ok( 'KeenCell');
    $numberOfTests++;


my $testX=KeenCell->new("9", "X");
print    $testX->toPrint();


is( $testX->isCellSolved(), 0, "testing if Cell is solved");
    $numberOfTests++;

checkForcingCellState();

checkPencilMarks();


checkSolvedFlag();


my $testY=KeenCell->new("9", "Y");       # secondary cell partnered with X


$testX=KeenCell->new("9", "X");
$testX->setMathEquation(  "7d", $testY);
is( $testX->getOperator(), "d", "testing if operator is d from 7d");
    $numberOfTests++;
is( $testX->getSolution(), "7", "testing if solution is 7 from 7d");
    $numberOfTests++;

$testX->setMathEquation(  "+17", $testY);
is( $testX->getOperator(), "+", "testing if operator is + from +17");
    $numberOfTests++;
is( $testX->getSolution(), "17", "testing if solution is 17 from +17");
    $numberOfTests++;

$testX->setMathEquation(  "17+", $testY);
is( $testX->getOperator(), "+", "testing if operator is + from 17+");
    $numberOfTests++;
is( $testX->getSolution(), "17", "testing if solution is 17 from 17+");
    $numberOfTests++;

print    $testX->toPrint();
$testY->setMathEquation(  "+17", $testX, $testZ);
#print    $testY->toPrint();
 
is( $testX->numberOfPartners(), 1, "count the number of Math partners for X");
    $numberOfTests++;
is( $testY->numberOfPartners(), 2, "count the number of Math partners for Y");
    $numberOfTests++;

$testX->solveByMath(  );
note( "addition to 17" );

    print $testX->printFullCell();
    print $testY->printFullCell();

is( $testX->numberPencils(), 2, "Eliminated the values in X that don't +17" );
    $numberOfTests++;
is( $testY->numberPencils(), 2, "Eliminated the values in Y that don't +17" );
    $numberOfTests++;

$testX=KeenCell->new("9", "X");
$testY=KeenCell->new("9", "Y");
$testX->setMathEquation(  "x18" , $testY);
$testY->setMathEquation(  "x18" , $testX);
$testX->solveByMath(   );
note( "multi to 18" );
print    $testX->toPrint();
is( $testX->numberPencils(), 4, "Eliminated the values in X that don't x18" );
    $numberOfTests++;


$testX=KeenCell->new("9", "X");
$testY=KeenCell->new("9", "Y");
$testX->setMathEquation(  "-4" , $testY);
$testY->setMathEquation(  "-4" , $testX);
$testX->solveByMath(   );
is( $testX->numberPencils(), 9, "Eliminated those that don't -4" );
    $numberOfTests++;
note( "subtract to 4" );
print    $testX->toPrint();



$testX=KeenCell->new("9", "X");
$testY=KeenCell->new("9", "Y");
$testX->setMathEquation(  "d5" , $testY);
is( $testX->getOperator(), "d", "testing if operator is d from d5");
    $numberOfTests++;
is( $testX->getSolution(), "5", "testing if solution is 5 from d5");
    $numberOfTests++;

$testY->setMathEquation(  "5d" , $testX);
is( $testY->getOperator(), "d", "testing if operator is d from 5d");
    $numberOfTests++;
is( $testY->getSolution(), "5", "testing if solution is 5 from 5d");
    $numberOfTests++;

$testX->solveByMath(   );
is( $testX->numberPencils(), 2, "Eliminated the values in X that don't divide to 5" );
    $numberOfTests++;
is( $testY->numberPencils(), 2, "Eliminated the values in Y that don't divide to 5" );
    $numberOfTests++;
note( "divisable to 5" );
print    $testX->toPrint();


test3factors();
test4factors();

done_testing( $numberOfTests);


#=== {{{1     SUBROUTINE FUNCTIONS  ================================================================

sub checkForcingCellState {

    my $testX=KeenCell->new("9", "X");

    print $testX->toPrint();
    $testX->setCellState( 8);
    print $testX->toPrint();

    is( $testX->isCellSolved(), 1, "testing if Cell is solved");
        $numberOfTests++;
    is( $testX->getCellsAnswer(), 8, "testing if Cells answer is 8");
        $numberOfTests++;
    is( $testX->numberPencils(), 1, "Solved the cell");
        $numberOfTests++;

    print $testX->printFullCell();



}
#===  FUNCTION  ================================================================
#{{{1     NAME: checkPencilMarks
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub checkPencilMarks {


    note("running checkPencilMarks()");

    my $testX=KeenCell->new("9", "X");

    my @a = $testX->getRefOfCellPencilMarks();
#note "ishow array";
#print Data::Dumper->Dump( [@a],  [qw(array) ] ) . "\n";
#note "end of array";

    my $cmp = new Data::Compare( @a, \[1 .. 9 ] );

    is( $cmp->Cmp(), 1, "testing if Cell holds all nine possibilites ");
        $numberOfTests++;

    is( $testX->removeValues( 4), 8, "testing of removing just one possibility");
        $numberOfTests++;
#print    $testX->toPrint();

    is( $testX->removeValues( 5, 3) , 6, "testing of removing two possibilities");
        $numberOfTests++;


}

#===  FUNCTION  ================================================================
#{{{1     NAME: checkSolvedFlag
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub checkSolvedFlag {

    note("running checkSolvedFlag()");
    my $testX=KeenCell->new("9", "X");


    is( $testX->isCellSolved(), 0, "testing if Cell is not solved");
        $numberOfTests++;
    is( $testX->removeValues( 1,3,4,5,6,7,8,9 ) , 1, "testing of removing all but one possibility");
        $numberOfTests++;
    is( $testX->isCellSolved(), 1, "testing if Cell is solved");
        $numberOfTests++;
        #my @a = $testX->getArrayOfCellPencilMarks();
    my $r = $testX->getArrayOfCellPencilMarks();
    my $ans = $testX->getCellsAnswer();
    #my @b = $testX->getRefOfCellPencilMarks();

    #print Data::Dumper->Dump( [\@a,  \$r ],  [qw(array ref) ] ) . "\n";
    #is( $a[0][0], 1, "testing if last Pencil mark is 1");
    #$numberOfTests++;
    #
    is( $r->[0], 2, "testing if last Pencil mark is 2");
        $numberOfTests++;
    is( $ans, 2, "testing if last Pencil mark is 2");
        $numberOfTests++;


}
#===  FUNCTION  ================================================================
#{{{1     NAME: test3factors
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub test3factors {
    note( "running test3factors() :");
    my $testZ=KeenCell->new("9", "Z");      #third cell in eqaution
    my $testX=KeenCell->new("9", "X");
    my $testY=KeenCell->new("9", "Y");

    $testX->setMathEquation(  "x18" , $testY, $testZ);
    $testY->setMathEquation(  "x18" , $testX, $testZ);
    $testZ->setMathEquation(  "x18" , $testX, $testY);
    $testX->solveByMath(   );
    #print    $testX->toPrint();
    note( "multi to 18 on 3 cells" );
    is( $testX->numberPencils(), 5, "Eliminated the values in X that don't x18 for 3 cells" );
    $numberOfTests++;
    is( $testY->numberPencils(), 5, "Eliminated the values in Y that don't x18 for 3 cells" );
    $numberOfTests++;
    is( $testZ->numberPencils(), 5, "Eliminated the values in Z that don't x18 for 3 cells" );
    $numberOfTests++;

    print $testX->printFullCell(). "\n";

    print $testY->printFullCell(). "\n";

    print $testZ->printFullCell(). "\n";

}   # end of test3factors





#===  FUNCTION  ================================================================
#{{{1     NAME: test4factors
#      PURPOSE: 
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub test4factors {
    note( "running test4factors() :");
    my $testU=KeenCell->new("9", "U");
    my $testW=KeenCell->new("9", "W");
    my $testX=KeenCell->new("9", "X");
    my $testY=KeenCell->new("9", "Y");
    my $testZ=KeenCell->new("9", "Z");

    $testW->setMathEquation(  "x18" , $testX, $testY, $testZ);
    $testX->setMathEquation(  "x18" , $testW, $testY, $testZ);
    $testY->setMathEquation(  "x18" , $testW, $testX, $testZ);
    $testZ->setMathEquation(  "x18" , $testW, $testX, $testY);

    $testX->solveByMath(   );
    #print    $testX->toPrint();
    note( "multi to 18 on 4 cells" );
    is( $testX->numberPencils(), 5, "Eliminated the values in X that don't x18 for 4 cells" );
    $numberOfTests++;
    is( $testY->numberPencils(), 5, "Eliminated the values in Y that don't x18 for 4 cells" );
    $numberOfTests++;
    is( $testZ->numberPencils(), 5, "Eliminated the values in Z that don't x18 for 4 cells" );
    $numberOfTests++;

    print $testW->printFullCell();
    print $testX->printFullCell();
    print $testY->printFullCell();
    print $testZ->printFullCell();

}   # end of test4factors






# }}}1
# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround:set foldenable foldmethod=marker:
