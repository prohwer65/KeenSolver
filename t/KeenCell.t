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
use Test::More tests => 12;                      # last test to print
use Data::Compare;


use_ok( 'KeenCell');


my $testX=KeenCell->new("9");
print    $testX->toPrint();


is( $testX->isCellSolved(), 0, "testing if Cell is solved");

my @a = $testX->getCellStates();
#note "ishow array";
#print Data::Dumper->Dump( [@a],  [qw(array) ] ) . "\n";
#note "end of array";

my $cmp = new Data::Compare( @a, \[1 .. 9 ] );

is( $cmp->Cmp(), 1, "testing if Cell holds all nine possibilites ");

is( $testX->removeValues( 4), 8, "testing of removing just one possibility");
#print    $testX->toPrint();

is( $testX->removeValues( 5, 3) , 6, "testing of removing two possibilities");


is( $testX->isCellSolved(), 0, "testing if Cell is solved");
is( $testX->removeValues( 2,3,4,5,6,7,8,9 ) , 1, "testing of removing all but one possibility");
is( $testX->isCellSolved(), 1, "testing if Cell is solved");


$testX=KeenCell->new("9");
$testX->setMathEquation(  "+17" );
$testX->solveByMath(  qw( 1 2 3 4 5 6 7 8 9) );
note( "addition to 17" );
print    $testX->toPrint();
is( $testX->numberPencils(), 2, "Eliminated those that don't +17" );


$testX=KeenCell->new("9");
$testX->setMathEquation(  "x18" );
$testX->solveByMath(  qw( 1 2 3 4 5 6 7 8 9) );
note( "multi to 18" );
print    $testX->toPrint();
is( $testX->numberPencils(), 4, "Eliminated those that don't x18" );


$testX=KeenCell->new("9");
$testX->setMathEquation(  "-4" );
$testX->solveByMath(  qw( 1 2 3 4 5 6 7 8 9) );
is( $testX->numberPencils(), 9, "Eliminated those that don't -4" );
note( "subtract to 4" );
print    $testX->toPrint();



$testX=KeenCell->new("9");
$testX->setMathEquation(  "d5" );
$testX->solveByMath(  qw( 1 2 3 4 5 6 7 8 9) );
is( $testX->numberPencils(), 2, "Eliminated those that don't divide to 5" );
note( "divisable to 5" );
print    $testX->toPrint();

print $testX->printCell(0).  " |row 0 \n";
print $testX->printCell(1).  " |row 1 \n";
print $testX->printCell(2).  " |row 2 \n";










done_testing();

# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround 
