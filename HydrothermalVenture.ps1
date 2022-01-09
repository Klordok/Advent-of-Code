<# 
Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 
where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. 
These line segments include the points at both ends. In other words:

    An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
    An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.

For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. 

Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
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
        if(($CoordPairs.x1 -eq $CoordPairs.x2) -or ($CoordPairs.y1 -eq $CoordPairs.y2)){
            #if x's or y's match it is a valid coordinate
            $ValidCoordinates.Add($CoordPairs)
        }
    }
}

function Find-Overlap {
    param (
        $Coordinates
    )
    #determine the number of points where at least two lines overlap
    <# 
    Find XY bounds of coordinate set
    Create list of coordinates in grid
    for each coordinate check if at least 2 lines intersect
    add point to list
    #>
    $xMax = ($Coordinates.x1+$Coordinates.x2 | Measure-Object -Maximum).Maximum
    $xMin = ($Coordinates.x1+$Coordinates.x2 | Measure-Object -Minimum).Minimum
    $yMax = ($Coordinates.y1+$Coordinates.y2 | Measure-Object -Maximum).Maximum
    $yMin = ($Coordinates.y1+$Coordinates.y2 | Measure-Object -Minimum).Minimum

    $markedPoints = New-Object -TypeName "System.Collections.ArrayList"
    <#
    this is very inefficient but it works. takes about 35 minutes to complete
    better way:
    $linePoints = @{}
    foreach($coord -in $Coordinates){
        if($coord.x1 -eq $coord.x2){
            foreach($y in $yLow..$yHigh){
                $linePoints.Add(@{
                    x = $coord.x1
                    y = $y
                })
            }
        }
        #same for y
    }
    Count all $linePoints with duplicates
    #>
    foreach ($x in $xMin..$xMax) {
        foreach ($y in $yMin..$yMax){
            foreach ($coord in $Coordinates) {
                if (($coord.x1 -eq $coord.x2) -and ($x -eq $coord.x1)) {
                    #check vertical line
                    $yBound = ($coord.y1,$coord.y2) | Sort-Object
                    if (($y -ge $yBound[0]) -and ($y -le $yBound[1])) {
                        #point is inside vertical line
                        #Write-Host "($x,$y) between ($($coord.x1),$($coord.y1)) and ($($coord.x2),$($coord.y2))"
                        $markedPoints.Add([PSCustomObject]@{              
                            x = $x
                            y = $y
                        }) | Out-Null
                    }
                }
                elseif (($coord.y1 -eq $coord.y2) -and ($y -eq $coord.y1)) {
                    #check horizontal line
                    $xBound = ($coord.x1,$coord.x2) | Sort-Object
                    if (($x -ge $xBound[0]) -and ($x -le $xBound[1])) {
                        #point is inside horizontal line
                        #Write-Host "($x,$y) between ($($coord.x1),$($coord.y1)) and ($($coord.x2),$($coord.y2))"
                        $markedPoints.Add([PSCustomObject]@{              
                            x = $x
                            y = $y
                        }) | Out-Null
                    }
                }
            }
        }
    }
    $OverlapCount = ($markedPoints | Group-Object -Property x,y | Select-Object Name,Count | Where-Object{$_.Count -ge 2}).count
    Write-Host "Answer: $OverlapCount"
}

function Add-LinePoints {
    param (
        $Coordinates
    )
    #find coordinates for all points in line segments
    #add to $linePoints
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
        else{
            #horizontal line
            foreach($x in ($coord.x1)..($coord.x2)){
                $linePoints.Add([PSCustomObject]@{
                    x = $x
                    y = $coord.y1
                }) | Out-Null
            }
        }

    }
    #Count all $linePoints with duplicates

    Sort-Coords -CoordList $linePoints
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
                $DupeCoords.Add($current)
                $lastAdded.x = $current.x
                $lastAdded.y = $current.y
            }
        }
        $previous.x = $current.x
        $previous.y = $current.y
    }

    $DuplicateCount = $DupeCoords.Count
    $DupeCoords | Out-File .\DupeCoords.txt
    Write-Host "Answer: $DuplicateCount"
}

Convert-Coordinates -RawCoordinates $VentCoordinates
#$ValidCoordinates

#Find-Overlap -Coordinates $ValidCoordinates
#Answer: 5084

Add-LinePoints -Coordinates $ValidCoordinates
#Klordok: 5306