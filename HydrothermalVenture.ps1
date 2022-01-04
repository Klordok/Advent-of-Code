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

Convert-Coordinates -RawCoordinates $TestCoordinates
$ValidCoordinates