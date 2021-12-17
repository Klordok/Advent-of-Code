#https://adventofcode.com/2021/day/1
<#
count the number of times a depth measurement increases from the previous measurement. (There is no measurement before the first measurement.) 
#>
$measurements = Get-Content -Path .\sonarReadings.txt

$previous = $measurements[0]
Write-Host "First measurement is $previous"
$increases = 0
foreach($depth in $measurements){
    if($depth -gt $previous){
        #Write-Host "$depth > $previous"
        $increases += 1
    }
    $previous = $depth
}
$increases
#final answer 1680. actual answer 1681