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

use Test::More ;  # tests => 1;                      # last test to print

use lib qw ( . .. );
use Data::Dumper;


use_ok( "KeenBoard");

note( "Create a board");
my $test = KeenBoard->new("5");


note( "Print board");
#print $test->toPrint();
print $test->printBoard();

note( "Solve cell 2,2 to 5 ");
$test->setCellState( 2, 2, 5);
print $test->printBoard();



done_testing();
##################################################################
#
#
#
##################################################################

# vim:tabstop=4:si:expandtab:shiftwidth=4:shiftround
