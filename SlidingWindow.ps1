<#
day 1 part 2
Considering every single measurement isn't as useful as you expected: there's just too much noise in the data.

Instead, consider sums of a three-measurement sliding window.
Your goal now is to count the number of times the sum of measurements in this sliding window increases from the previous sum. 
So, compare A with B, then compare B with C, then C with D, and so on. 
Stop when there aren't enough measurements left to create a new three-measurement sum.
#>
$measurements = Get-Content -Path .\sonarReadings.txt
$setSize = $measurements.Length
$index = 0
$increases = 0
$previous = [int]$measurements[$index]+[int]$measurements[$index+1]+[int]$measurements[$index+2]
Write-Host "Starting with $previous"
while ($index -lt $setSize-2) {
    #sum sets of 3 then compare
    $windowSum = [int]$measurements[$index]+[int]$measurements[$index+1]+[int]$measurements[$index+2]
    if ($windowSum -gt $previous) {
        #Write-Host "$windowSum > $previous"
        $increases += 1
    }
    $previous = $windowSum
    $index += 1
}
$increases
#answer: 1704