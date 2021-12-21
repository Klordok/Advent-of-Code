<#
Bingo
Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. 
Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. 
(Numbers may not appear on all boards.) 
If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

The score of the winning board can now be calculated. 
Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. 
Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

To guarantee victory against the giant squid, figure out which board will win first. 
What will your final score be if you choose that board?
#>

$bingoInput = (Get-Content .\bingoInput.txt -Raw)

$splitInput = $bingoInput -split "\r?\n\r?\n"

$numberList = $splitInput[0]

$boardList = $splitInput[1..($splitInput.count-1)]

function Check-Board {
    #Check board for number
    #Mark number
    #Check for bingo
    param (
        $board,
        $number
    )
    
}

foreach($number in $numberList){
    #check each board for number
    #mark number. (change symbol?)
    #Check if bingo
    foreach($board in $boardList){
        Check-Board
    }
}
