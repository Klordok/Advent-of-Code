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

$FishList = $InitialState.Split(",")
$FishState = [List[int]]@($FishList)
$days = 256

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

function Set-PopState (){
  [CmdletBinding()]
  param (
      $InitialState
  )
  $AgeDistribution = [Ordered]@{
    cycle0=0
    cycle1=0
    cycle2=0
    cycle3=0
    cycle4=0
    cycle5=0
    cycle6=0
    cycle7=0
    cycle8=0
  }
  foreach($fish in $InitialState){
    #count number of fish at each point in their cycle
    switch ($fish) {
      0 { $AgeDistribution["cycle0"] += 1 }
      1 { $AgeDistribution["cycle1"] += 1 }
      2 { $AgeDistribution["cycle2"] += 1 }
      3 { $AgeDistribution["cycle3"] += 1 }
      4 { $AgeDistribution["cycle4"] += 1 }
      5 { $AgeDistribution["cycle5"] += 1 }
      6 { $AgeDistribution["cycle6"] += 1 }
      7 { $AgeDistribution["cycle7"] += 1 }
      8 { $AgeDistribution["cycle8"] += 1 }
      Default {}
    }
  }
  $AgeDistribution
  Update-Population -StartingAges $AgeDistribution -Days $days
}

function Update-Population {
  param (
    $StartingAges,
    $Days
  )
  foreach ($day in 1..$Days){
    #age the population
    $tempVal = $AgeDistribution["cycle0"]
    $AgeDistribution["cycle0"] = $AgeDistribution["cycle1"]
    $AgeDistribution["cycle1"] = $AgeDistribution["cycle2"]
    $AgeDistribution["cycle2"] = $AgeDistribution["cycle3"]
    $AgeDistribution["cycle3"] = $AgeDistribution["cycle4"]
    $AgeDistribution["cycle4"] = $AgeDistribution["cycle5"]
    $AgeDistribution["cycle5"] = $AgeDistribution["cycle6"]
    $AgeDistribution["cycle6"] = $AgeDistribution["cycle7"]
    $AgeDistribution["cycle7"] = $AgeDistribution["cycle8"]
    $AgeDistribution["cycle8"] = $tempVal
    $AgeDistribution["cycle6"] += $tempVal
    #Write-Output "Day $day :"
    #Write-Output $AgeDistribution
  }
  $TotalFish = 0
  foreach ($group in $AgeDistribution.Values) {
    $TotalFish += $group  
  }
  
  Write-Host "`nTotalFish after $days days: $TotalFish"
  $AgeDistribution
}


Set-PopState -InitialState $FishState

#Answer: 1613415325809

