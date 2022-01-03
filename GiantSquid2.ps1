<#
Figure out which board will win last. Once it wins, what would its final score be?
#>

$bingoInput = Get-Content .\bingoInput.txt -Raw

$splitInput = $bingoInput -split "\r?\n\r?\n"

$numberList = $splitInput[0].Split(',')

$allBoardStrings = $splitInput[1..($splitInput.count-1)]

#convert boards to multidimentional arrays
$allBoardArray = New-Object -TypeName "System.Collections.ArrayList"

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
    $allBoardArray.Add($board)
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

function Find-Matches {
    param (
        $allBoards
    )
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

                        #remove board?
                        if($allBoards.Count -gt 1){
                            $allBoards.Remove($allBoards[$boardIndex])
                            Write-Output "Board $boardIndex eliminated"
                            Find-Matches -allBoards $allBoards
                        }
                        else{
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
}
foreach($number in $numberList){
    #check each board for number
    #Write-Output "Looking for $number"
    #mark number. (change symbol?)
    #Check if bingo
    Find-Matches -allBoards $allBoardArray
}
#Answer: 13884