<# 
Because of the limits of the hydrothermal vent mapping system, 
the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. 
In other words:

    An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
    An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

Consider all of the lines. At how many points do at least two lines overlap?
#>
$VentCoordinates = Get-Content .\VentCoordinates.txt
$TestCoordinates = @"
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"@.Split("`n")

$ValidCoordinates = New-Object -TypeName "System.Collections.ArrayList"

function Convert-Coordinates {
    #convert from string to key value pairs
    param (
        $RawCoordinates
    )

    foreach ($line in $RawCoordinates) {
        $CoordValues = $line.replace(" -> ",",").split(',')
        $CoordPairs = [PSCustomObject]@{
            x1 = [int]$CoordValues[0]
            y1 = [int]$CoordValues[1]
            x2 = [int]$CoordValues[2]
            y2 = [int]$CoordValues[3]
        }
        if(($CoordPairs.x1 -eq $CoordPairs.x2) -or ($CoordPairs.y1 -eq $CoordPairs.y2) -or 
        ([Math]::Abs(($CoordPairs.y1 - $CoordPairs.y2)/($CoordPairs.x1 - $CoordPairs.x2)) -eq 1)){
            #if x's or y's match or slope is 1 it is a valid coordinate
            $ValidCoordinates.Add($CoordPairs) | Out-Null
        }
    }
}

function Add-LinePoints {
    param (
        $Coordinates
    )
    #find coordinates for all points in line segments
    #add to $linePoints
    #count all coordinates with duplicates
    $linePoints = New-Object -TypeName "System.Collections.ArrayList"
    foreach($coord in $Coordinates){
        if($coord.x1 -eq $coord.x2){
            #vertical line
            foreach($y in ($coord.y1)..($coord.y2)){
                $linePoints.Add([PSCustomObject]@{
                    x = $coord.x1
                    y = $y
                }) | Out-Null
            }
        }
        #same for y
        elseif($coord.y1 -eq $coord.y2){
            #horizontal line
            foreach($x in ($coord.x1)..($coord.x2)){
                $linePoints.Add([PSCustomObject]@{
                    x = $x
                    y = $coord.y1
                }) | Out-Null
            }
        }
        else {
            #diagonal
            $xCoords = ($coord.x1)..($coord.x2)
            $yCoords = ($coord.y1)..($coord.y2)
            foreach ($i in 0..($xCoords.count - 1)) {
                $linePoints.Add([PSCustomObject]@{
                    x = $xCoords[$i]
                    y = $yCoords[$i]
                }) | Out-Null
            }
        }
    }
    #Count all $linePoints with duplicates

    Sort-Coords -CoordList $linePoints
}
function Find-Overlap {
    param (
        $linePoints
    )
    #determine the number of points where at least two lines overlap
    $linePoints.Count
    $OverlapPoints = $linePoints | Group-Object -Property x,y | Select-Object Count | Where-Object{$_.Count -ge 2}
    $OverlapCount = $OverlapPoints.count
    Write-Host "Answer: $OverlapCount"
    #Find-Overlap -linePoints $linePoints
}

function Sort-Coords($CoordList){
    $Sorted = $CoordList | Sort-Object x,y
    $Sorted | Out-File .\SortedCoords.txt
    Write-Host "Sorted list. Checking $($Sorted.count) coordinates"
    $DupeCoords = New-Object -TypeName "System.Collections.ArrayList"
    $previous = [PSCustomObject]@{
        x = $null
        y = $null
    }
    $lastAdded = [PSCustomObject]@{
        x = $null
        y = $null
    }
    foreach($current in $Sorted){
        #if current matches previous and has not already been added, add to DupeCoords.
        if(($current.x -ne $lastAdded.x) -or ($current.y -ne $lastAdded.y)){
            if(($current.x -eq $previous.x) -and ($current.y -eq $previous.y)){
                $DupeCoords.Add($current) | Out-Null
                $lastAdded.x = $current.x
                $lastAdded.y = $current.y
            }
        }
        $previous.x = $current.x
        $previous.y = $current.y
    }

    $DuplicateCount = $DupeCoords.Count
    Write-Host "Answer: $DuplicateCount"
}

Convert-Coordinates -RawCoordinates $VentCoordinates
#$ValidCoordinates
Add-LinePoints -Coordinates $ValidCoordinates
#Klordok Answer: 17787