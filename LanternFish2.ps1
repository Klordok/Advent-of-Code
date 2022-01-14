<# 
Suppose the lanternfish live forever and have unlimited food and space. Would they take over the entire ocean?

After 256 days in the example above, there would be a total of 26984457539 lanternfish!

How many lanternfish would there be after 256 days?
#>
using namespace System.Collections.Generic
using namespace System
$TestState = "0,0"
$InitialState = Get-Content -Path .\LanternFishData.txt

#For each day:
#0 becomes 6
#add new 8 to list
#decrease all other numbers by 1

#calculating entire pop for each cycle is too slow.

$FishList = $TestState.Split(",")
$FishState = [List[int]]@($FishList)
$days = 1

function Count-Descendants(){
  param(
    $daysToSpawn,
    $RemainingDays
  )
  # (Children of Gen1)*(Children of Gen 2)...until no more days
  $children = [Math]::Ceiling(($RemainingDays - $daysToSpawn)/7)
  if($RemainingDays - $daysToSpawn -ge 1){
    
  }  
}

#Answer:

