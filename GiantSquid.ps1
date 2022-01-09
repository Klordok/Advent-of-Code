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

$bingoInput = Get-Content .\bingoInput.txt -Raw

$splitInput = $bingoInput -split "\r?\n\r?\n"

$numberList = $splitInput[0].Split(',')

$allBoardStrings = $splitInput[1..($splitInput.count-1)]

#convert boards to multidimentional arrays
$allBoards = New-Object -TypeName "System.Collections.ArrayList"

foreach($boardString in $allBoardStrings){
    $board = New-Object -TypeName "System.Collections.ArrayList"
    $rowStrings = $boardString.Split("`n")
    foreach ($row in $rowStrings) {
        #convert row to an int array
        $rowList = @()
        [int[]]$rowValues = $row.trim().replace("  "," ").split()
        $rowList += $rowValues
        $board.Add($rowList)
    }
    #creates a 3 dimensional array. board,row,column
    $allBoards.Add($board)
}

function Find-Bingo {
    #Check board for bingo
    #check rows for "xxxxx"
    #check columns for "xxxxx"

    param (
        $board
    )
    $bingoArray = @('x','x','x','x','x')
    foreach ($row in $board) {
        if((Compare-Object -ReferenceObject $bingoArray -DifferenceObject $row).count -eq 0){
            #row bingo
            return $true
        }
    }
    foreach ($column in 0..4) {
        $columnArray = @($board[0][$column],$board[1][$column],$board[2][$column],$board[3][$column],$board[4][$column])
        if((Compare-Object -ReferenceObject $bingoArray -DifferenceObject $columnArray).count -eq 0){
            #column bingo
            return $true
        }
    }
}

function Find-BoardSum {
    #sum all unmarked numbers on board
    param(
        $winningBoard
    )
    $boardSum = 0
    foreach ($row in $winningBoard) {
        foreach ($item in $row){
            if($item -is [int]){
                $boardSum += $item
            }
        }
    }
    return $boardSum
}

foreach($number in $numberList){
    #check each board for number
    #Write-Output "Looking for $number"
    #mark number. (change symbol?)
    #Check if bingo
    foreach($boardIndex in 0..($allBoards.Count-1)){
        #search each board for matching number
        if($allBoards[$boardIndex] -match [int]$number){
            #search each row in board
            foreach ($rowIndex in 0..4) {
                $column = $allBoards[$boardIndex][$rowIndex].IndexOf([int]$number)
                #if number exists get the index and mark the board
                if($column -ne -1){
                    $allBoards[$boardIndex][$rowIndex][$column] = 'x'
                    #Write-Output "Found $number in board $boardIndex"
                    if(Find-Bingo -board $allBoards[$boardIndex]){
                        #found bingo
                        Write-Output "Board $boardIndex Bingo!"
                        $boardSum = Find-BoardSum -winningBoard $allBoards[$boardIndex]
                        $answer = $boardSum*([int]$number)
                        Write-Output "Answer: $answer"
                        exit
                    }
                }
            }
        }    
    }
}
#answer: 29440
#Klordok: 6592