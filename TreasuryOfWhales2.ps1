<# 
As each crab moves, moving further becomes more expensive. 
This changes the best horizontal position to align them all on; 
in the example above, this becomes 5:

    Move from 16 to 5: 66 fuel
    Move from 1 to 5: 10 fuel
    Move from 2 to 5: 6 fuel
    Move from 0 to 5: 15 fuel
    Move from 4 to 5: 1 fuel
    Move from 2 to 5: 6 fuel
    Move from 7 to 5: 3 fuel
    Move from 1 to 5: 10 fuel
    Move from 2 to 5: 6 fuel
    Move from 14 to 5: 45 fuel

This costs a total of 168 fuel. This is the new cheapest possible outcome; 
the old alignment position (2) now costs 206 fuel instead.

Determine the horizontal position that the crabs can align to using the least fuel possible so they can make you an escape route! 
How much fuel must they spend to align to that position?
#>
using namespace System.Collections.Generic

$TestInput = 16,1,2,0,4,2,7,1,2,14

$CrabPositions = [List[int]]@((Get-Content .\TreasuryOfWhales.txt).Split(","))
$CrabPositions.Count

function Find-EfficientPosition {
    param (
        $HorizontalPositions
    )
    $Sorted = $HorizontalPositions | Sort-Object
    $TotalFuel = 0
    #Find mean position
    $MeanPosition = [Math]::Floor(($HorizontalPositions | Measure-Object -Average).Average)
    Write-Host "Average: $MeanPosition"
    foreach($position in $Sorted){
        $Distance = [Math]::Abs($position - $MeanPosition) 
        $FuelCost = 0
        foreach($i in 1..$Distance){
          $FuelCost += $i
        }
        $TotalFuel += $FuelCost
    }
    Write-Host "$TotalFuel Fuel"
}

Find-EfficientPosition -HorizontalPositions $CrabPositions
#Average: 489 (actual 488.52)
#101618153 is too high

#Average 488 (actual 488.52)
#101618069 is correct