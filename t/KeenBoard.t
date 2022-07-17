#
#===============================================================================
#
#         FILE: KeenBoard.t
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Paul Rohwer (PWR), prohwer@mindspring.com
# ORGANIZATION: PowerAudio
#      VERSION: 1.0
#      CREATED: 6/23/2022 7:21:23 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Test::More ;                       # last test to print

use lib qw ( . .. );
use Data::Dumper;

my $numberOfTests=0;

use_ok( "KeenBoard");
    $numberOfTests++;

note( "Create a board");
my $test = KeenBoard->new("5");


note( "Print board");
#print $test->toPrint();
print $test->printBoard();

note( "Solve cell 2,2 to 5 ");
$test->setCellState( 2, 2, 5);
print $test->printBoard();

note( "Solve cell 0,0 to 1 ");
$test->setCellState( 0, 0, 1);
print $test->printBoard();

print $test->printTitles();

testBySolveByMath();
done_testing( $numberOfTests);

##################################################################
##################################################################
##################################################################
#
#
#
sub testBySolveByMath {

    my $test = KeenBoard->new("5");

    $test->defineCellRelation( "+9", [0,0], [0,1], [0,2] );
    $test->defineCellRelation( "d2", [0,3], [0,4] );
    $test->defineCellRelation( "-1", [1,0], [1,1] );
    $test->defineCellRelation( "2d", [1,2], [1,3] );
    $test->defineCellRelation( "1-", [1,4], [2,4] );
    $test->defineCellRelation( "x15", [2,0], [3,0] );
    $test->defineCellRelation( "x20", [2,1], [2,2], [2,3] );
    $test->defineCellRelation( "2d", [3,1], [3,2] );
    $test->defineCellRelation( "+10", [3,3], [4,3], [4,2] );

    $test->defineCellRelation( "1-", [4,0], [4,1] );
    $test->defineCellRelation( "5x", [3,4], [4,4] );

    print $test->printEquations();
    print $test->printBoard();
    $test->solveByMath();
    print $test->printBoard();

}
##################################################################
#
#
#
##################################################################

# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround