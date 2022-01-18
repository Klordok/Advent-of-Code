<# 
For example, consider the following horizontal positions:

16,1,2,0,4,2,7,1,2,14

This means there's a crab with horizontal position 16, a crab with horizontal position 1, and so on.

Each change of 1 step in horizontal position of a single crab costs 1 fuel. 
You could choose any horizontal position to align them all on, 
but the one that costs the least fuel is horizontal position 2:

    Move from 16 to 2: 14 fuel
    Move from 1 to 2: 1 fuel
    Move from 2 to 2: 0 fuel
    Move from 0 to 2: 2 fuel
    Move from 4 to 2: 2 fuel
    Move from 2 to 2: 0 fuel
    Move from 7 to 2: 5 fuel
    Move from 1 to 2: 1 fuel
    Move from 2 to 2: 0 fuel
    Move from 14 to 2: 12 fuel

This costs a total of 37 fuel. This is the cheapest possible outcome; 
more expensive outcomes include aligning at position 1 (41 fuel), position 3 (39 fuel), or position 10 (71 fuel).

Determine the horizontal position that the crabs can align to using the least fuel possible. 
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
    $HorizontalPositions | Group-Object | Sort-Object -Property Count -Descending
}

Find-EfficientPosition -HorizontalPositions $CrabPositions