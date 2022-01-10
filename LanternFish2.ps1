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

function Count-Children {
    param(
        $daysToSpawn,
        $duration
    )
    #how many children after x days?
    $spawnDays = $duration - $daysToSpawn
    $children = [System.Math]::ceiling($spawnDays/7)
    $children
    
}

function Count-Descendants() {
  $Descendants = 0
  foreach ($fish in $FishState){
    $Descendants += (Count-Children -daysToSpawn $fish -duration $days)
  }
  Write-Host "$Descendants"
}

function Explode-Fish {
  param (
    [int]$daysToSpawn,
    [int]$duration
  )
  $spawnDays = $duration - $daysToSpawn
  $cycles = [Math]::Ceiling($spawnDays/7)
  $population = $daysToSpawn*([Math]::Pow(2,$cycles))
  Write-Host "Explode-Fish counted $population fish after $days days" -ForegroundColor Green
}

function Age-Fish() {
  #Age fish 1 cycle
  $NewFish = 0
  foreach ($fish in 0..($FishState.Count - 1)) {
    #fish that are born get to rest this cycle
    if($FishState[$fish] -eq 0) {
      $FishState[$fish] = 6
      $NewFish += 1
    }
    else {
      $FishState[$fish] = $FishState[$fish]-1
    }
  }
  if($NewFish -ge 1){
    foreach($baby in 1..$NewFish){
      $FishState.Add(8)
    }
  }
}

function Grow-Population {
  #calculate population after x days
  param (
    $days
  )
  Write-Host "Starting with $($FishState.Count) fish"
  foreach ($day in 1..$days) {
    Age-Fish
    #Write-Host "Day $day : $($FishState.Count)"
  }
  Write-Host "Grow-Pop counted $($FishState.Count) fish after $days days" -ForegroundColor Green
}
Explode-Fish -fish $FishState.Count -days $days
Grow-Population -days $days

#Answer:

