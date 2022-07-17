#! /mu/bin/perl
#
#===============================================================================
#
#         FILE: KeenCell.t
#
#  DESCRIPTION: j
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer@micron.com
# ORGANIZATION: SpecTek
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


is( $testX->isCellSolved(), 0, "testing if Cell is solved");
    $numberOfTests++;
is( $testX->removeValues( 2,3,4,5,6,7,8,9 ) , 1, "testing of removing all but one possibility");
    $numberOfTests++;
is( $testX->isCellSolved(), 1, "testing if Cell is solved");
    $numberOfTests++;


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

print $testX->printCell(0).  " |row 0 for " . $testX->printTitle() . "\n";
print $testX->printCell(1).  " |row 1 \n";
print $testX->printCell(2).  " |row 2 \n";
print $testY->printCell(0).  " |row 0 for " . $testY->printTitle() . "\n";
print $testY->printCell(1).  " |row 1 \n";
print $testY->printCell(2).  " |row 2 \n";

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


sub test3factors {
    note( "test3factors() :");
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

    print $testX->printCell(0).  " |row 0 for " . $testX->printTitle() . "\n";
    print $testX->printCell(1).  " |row 1 \n";
    print $testX->printCell(2).  " |row 2 \n";

    print $testY->printCell(0).  " |row 0 for " . $testY->printTitle() . "\n";
    print $testY->printCell(1).  " |row 1 \n";
    print $testY->printCell(2).  " |row 2 \n";

    print $testZ->printCell(0).  " |row 0 for " . $testZ->printTitle() . "\n";
    print $testZ->printCell(1).  " |row 1 \n";
    print $testZ->printCell(2).  " |row 2 \n";

}





sub test4factors {
    note( "test4factors() :");
    my $testW=KeenCell->new("9", "W");
    my $testX=KeenCell->new("9", "X");
    my $testY=KeenCell->new("9", "Y");
    my $testZ=KeenCell->new("9", "Z");      #third cell in eqaution
    my $testZ=KeenCell->new("9", "Z");      #third cell in eqaution

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

    print $testW->printCell(0).  " |row 0 for " . $testW->printTitle() . "\n";
    print $testW->printCell(1).  " |row 1 \n";
    print $testW->printCell(2).  " |row 2 \n";

    print $testX->printCell(0).  " |row 0 for " . $testX->printTitle() . "\n";
    print $testX->printCell(1).  " |row 1 \n";
    print $testX->printCell(2).  " |row 2 \n";

    print $testY->printCell(0).  " |row 0 for " . $testY->printTitle() . "\n";
    print $testY->printCell(1).  " |row 1 \n";
    print $testY->printCell(2).  " |row 2 \n";

    print $testZ->printCell(0).  " |row 0 for " . $testZ->printTitle() . "\n";
    print $testZ->printCell(1).  " |row 1 \n";
    print $testZ->printCell(2).  " |row 2 \n";

}






# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround 
